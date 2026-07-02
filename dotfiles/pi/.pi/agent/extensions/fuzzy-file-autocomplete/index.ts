// Replaces the built-in @ file autocomplete with true fuzzy matching.

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import {
  type AutocompleteItem,
  type AutocompleteProvider,
  type AutocompleteSuggestions,
  fuzzyFilter,
} from "@earendil-works/pi-tui";
import { spawn } from "node:child_process";
import { basename } from "node:path";

const MAX_RESULTS = 20;
const MAX_FILES = 15000;
const CACHE_TTL_MS = 30_000;

function extractAtToken(textBeforeCursor: string): string | null {
  for (let i = textBeforeCursor.length - 1; i >= 0; i--) {
    const ch = textBeforeCursor[i];
    if (ch === "@") {
      const isTokenStart = i === 0 || /\s/.test(textBeforeCursor[i - 1] ?? "");
      if (isTokenStart) {
        return textBeforeCursor.slice(i + 1);
      }
    }
  }
  return null;
}

interface FdResult {
  files: string[];
  fdMissing?: boolean;
}

async function getAllFiles(cwd: string, signal: AbortSignal): Promise<FdResult> {
  return new Promise((resolve) => {
    if (signal.aborted) {
      resolve({ files: [] });
      return;
    }

    // Run fd for files
    const child = spawn(
      "fd",
      [
        "--base-directory",
        cwd,
        "--type",
        "f",
        "--follow",
        "--hidden",
        "--exclude",
        ".git",
        "--max-results",
        String(MAX_FILES),
      ],
      { stdio: ["ignore", "pipe", "pipe"] },
    );

    let stdout = "";
    let resolved = false;

    const finish = (result: FdResult) => {
      if (resolved) return;
      resolved = true;
      signal.removeEventListener("abort", onAbort);
      resolve(result);
    };

    const onAbort = () => {
      if (child.exitCode === null) child.kill("SIGKILL");
    };

    signal.addEventListener("abort", onAbort, { once: true });
    child.stdout.setEncoding("utf-8");
    child.stdout.on("data", (chunk: string) => {
      stdout += chunk;
    });
    child.on("error", () => finish({ files: [], fdMissing: true }));
    child.on("close", (code) => {
      if (signal.aborted || code !== 0) {
        finish({ files: [] });
        return;
      }
      const files = stdout
        .trim()
        .split("\n")
        .filter(Boolean)
        .map((p) => p.replace(/\\/g, "/"));
      finish({ files });
    });
  });
}

async function getAllDirs(cwd: string, signal: AbortSignal): Promise<string[]> {
  return new Promise((resolve) => {
    if (signal.aborted) {
      resolve([]);
      return;
    }

    const child = spawn(
      "fd",
      [
        "--base-directory",
        cwd,
        "--type",
        "d",
        "--follow",
        "--hidden",
        "--exclude",
        ".git",
        "--max-results",
        String(MAX_FILES),
      ],
      { stdio: ["ignore", "pipe", "pipe"] },
    );

    let stdout = "";
    let resolved = false;

    const finish = (results: string[]) => {
      if (resolved) return;
      resolved = true;
      signal.removeEventListener("abort", onAbort);
      resolve(results);
    };

    const onAbort = () => {
      if (child.exitCode === null) child.kill("SIGKILL");
    };

    signal.addEventListener("abort", onAbort, { once: true });
    child.stdout.setEncoding("utf-8");
    child.stdout.on("data", (chunk: string) => {
      stdout += chunk;
    });
    child.on("error", () => finish([]));
    child.on("close", (code) => {
      if (signal.aborted || code !== 0) {
        finish([]);
        return;
      }
      // Append trailing / to directories so they're distinguishable
      finish(
        stdout
          .trim()
          .split("\n")
          .filter(Boolean)
          .map((p) => p.replace(/\\/g, "/") + "/"),
      );
    });
  });
}

function buildSuggestions(paths: string[], query: string): AutocompleteItem[] {
  if (!query.trim()) {
    return paths.slice(0, MAX_RESULTS).map((p) => {
      const isDir = p.endsWith("/");
      const clean = isDir ? p.slice(0, -1) : p;
      return {
        value: `@${p}`,
        label: basename(clean) + (isDir ? "/" : ""),
        description: clean,
      };
    });
  }

  // Use Pi's own fuzzyFilter — this matches characters in order, not consecutively
  const filtered = fuzzyFilter(paths, query, (p) => p).slice(0, MAX_RESULTS);

  return filtered.map((p) => {
    const isDir = p.endsWith("/");
    const clean = isDir ? p.slice(0, -1) : p;
    return {
      value: `@${p}`,
      label: basename(clean) + (isDir ? "/" : ""),
      description: clean,
    };
  });
}

export default function (pi: ExtensionAPI): void {
  pi.on("session_start", (_event, ctx) => {
    let cachedFiles: string[] | undefined;
    let cacheTimestamp = 0;
    let cachePromise: Promise<string[]> | undefined;
    let fdMissingNotified = false;

    const getFiles = async (signal: AbortSignal): Promise<string[]> => {
      // Return cache if fresh
      if (cachedFiles && Date.now() - cacheTimestamp < CACHE_TTL_MS) {
        return cachedFiles;
      }

      // Invalidate stale cache so a new fetch starts
      if (cachedFiles && Date.now() - cacheTimestamp >= CACHE_TTL_MS) {
        cachePromise = undefined;
      }

      cachePromise ??= (async () => {
        const [fdResult, dirs] = await Promise.all([
          getAllFiles(ctx.cwd, signal),
          getAllDirs(ctx.cwd, signal),
        ]);

        if (fdResult.fdMissing && !fdMissingNotified) {
          fdMissingNotified = true;
          ctx.ui.notify(
            "fuzzy-file-autocomplete: 'fd' not found. Install it for fuzzy @ completion.",
            "error",
          );
        }

        const files = [...fdResult.files, ...dirs];

        // Don't cache empty results from aborted or failed calls
        if (files.length > 0) {
          cachedFiles = files;
          cacheTimestamp = Date.now();
        } else {
          cachePromise = undefined;
        }

        return files;
      })();
      return cachePromise;
    };

    ctx.ui.addAutocompleteProvider(
      (current: AutocompleteProvider): AutocompleteProvider => ({
        async getSuggestions(
          lines,
          cursorLine,
          cursorCol,
          options,
        ): Promise<AutocompleteSuggestions | null> {
          const currentLine = lines[cursorLine] ?? "";
          const textBeforeCursor = currentLine.slice(0, cursorCol);

          const atQuery = extractAtToken(textBeforeCursor);
          if (atQuery === null) {
            // Not an @ completion — delegate to built-in
            return current.getSuggestions(lines, cursorLine, cursorCol, options);
          }

          // If the query contains a "/" it's a scoped path — let the built-in handle it
          // (the built-in does directory-level completion well)
          if (atQuery.includes("/")) {
            return current.getSuggestions(lines, cursorLine, cursorCol, options);
          }

          const files = await getFiles(options.signal);
          if (options.signal.aborted || files.length === 0) {
            return current.getSuggestions(lines, cursorLine, cursorCol, options);
          }

          const suggestions = buildSuggestions(files, atQuery);
          if (suggestions.length === 0) {
            // Fall back to built-in in case our approach missed something
            return current.getSuggestions(lines, cursorLine, cursorCol, options);
          }

          return {
            items: suggestions,
            prefix: `@${atQuery}`,
          };
        },

        applyCompletion(lines, cursorLine, cursorCol, item, prefix) {
          return current.applyCompletion(lines, cursorLine, cursorCol, item, prefix);
        },

        shouldTriggerFileCompletion(lines, cursorLine, cursorCol) {
          return current.shouldTriggerFileCompletion?.(lines, cursorLine, cursorCol) ?? true;
        },
      }),
    );
  });
}

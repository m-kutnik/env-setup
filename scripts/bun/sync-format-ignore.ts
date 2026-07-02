/**
 * Regenerate ignore patterns in oxfmt.config.ts.
 * Sources: .gitignore, .gitmodules.
 *
 * Usage: bun scripts/sync-format-ignore.ts
 */

import { $ } from "bun";
import { resolve } from "node:path";
import { log, REPO_ROOT } from "./_utils/helpers";

// Merge, deduplicate, sort
const submodulePaths = await getModulesPaths();
const gitignorePatterns = await getGitignorePatterns();
const allPaths = [...new Set([...submodulePaths, ...gitignorePatterns])].sort((a, b) =>
  a.replace(/^!/, "").localeCompare(b.replace(/^!/, "")),
);

// Oxfmt
const oxfmtTemplate = resolve(import.meta.dir, "format-ignore-templates/oxfmt.config.ts");
const oxfmtText = await Bun.file(oxfmtTemplate).text();
const oxfmtEntries = allPaths.map((p) => `    "${p}",`).join("\n");
const fileContent = oxfmtText.replace(/^\s*\/\/ \$MARKER\$/m, oxfmtEntries);

await Bun.write(resolve(REPO_ROOT, "oxfmt.config.ts"), fileContent);
log.success(`Updated oxfmt.config.ts`);

async function getModulesPaths(): Promise<string[]> {
  const gitmodulesPath = resolve(REPO_ROOT, ".gitmodules");
  if (!(await Bun.file(gitmodulesPath).exists())) return [];

  const output = await $`git config --file .gitmodules --get-regexp ${"\\.path$"}`
    .cwd(REPO_ROOT)
    .text();

  return output
    .trim()
    .split("\n")
    .filter(Boolean)
    .map((line) => line.split(/\s+/)[1]!);
}

async function getGitignorePatterns(): Promise<string[]> {
  const gitignorePath = resolve(REPO_ROOT, ".gitignore");
  if (!(await Bun.file(gitignorePath).exists())) return [];

  const content = await Bun.file(gitignorePath).text();
  return content
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith("#"));
}

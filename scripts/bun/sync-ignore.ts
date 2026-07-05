/**
 * Regenerate ignore patterns in project files.
 * Sources: .gitignore, .gitmodules.
 *
 * Usage: bun scripts/sync-ignore.ts
 */

import { $ } from "bun";
import { resolve } from "node:path";
import { log, REPO_ROOT } from "./_utils/helpers";

// Merge, deduplicate, sort
const submodulePaths = await getModulesPaths();
const gitignorePatterns = await getGitignorePatterns();
const customPaths = [".DS_Store"];
const allPaths = Array.from(
  new Set([...submodulePaths, ...gitignorePatterns, ...customPaths]),
).sort(sortPaths);

// Oxfmt
const oxfmtTemplate = resolve(import.meta.dir, "sync-ignore-templates/oxfmt.config.ts");
const oxfmtText = await Bun.file(oxfmtTemplate).text();
const oxfmtEntries = allPaths.map((p) => `    "${p}",`).join("\n");
const fileContent = oxfmtText.replace(/^\s*\/\/ \$MARKER\$/m, oxfmtEntries);

await Bun.write(resolve(REPO_ROOT, "oxfmt.config.ts"), fileContent);
log.success(`Updated oxfmt.config.ts`);

// Zed settings - just ignore submodule paths
const zedSettingsTemplate = resolve(import.meta.dir, "sync-ignore-templates/zed-settings.json");
const zedSettingsText = await Bun.file(zedSettingsTemplate).text();
const zedSettingsEntries = Array.from(new Set([...submodulePaths, ...customPaths]))
  .map((p) => `    "${p}",`)
  .join("\n");
const zedSettingsContent = zedSettingsText.replace(/^\s*\/\/ \$MARKER\$/m, zedSettingsEntries);

await Bun.write(resolve(REPO_ROOT, ".zed/settings.json"), zedSettingsContent);
log.success(`Updated .zed/settings.json`);

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
    .map((line) => line.split(/\s+/)[1]!)
    .sort(sortPaths);
}

async function getGitignorePatterns(): Promise<string[]> {
  const gitignorePath = resolve(REPO_ROOT, ".gitignore");
  if (!(await Bun.file(gitignorePath).exists())) return [];

  const content = await Bun.file(gitignorePath).text();
  return content
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith("#"))
    .sort(sortPaths);
}

function sortPaths(a: string, b: string): number {
  return a.replace(/^!/, "").localeCompare(b.replace(/^!/, ""));
}

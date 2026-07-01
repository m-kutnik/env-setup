/**
 * Regenerate ignore patterns in oxfmt.config.ts and treefmt.toml.
 * Sources: .gitignore, .gitmodules.
 *
 * Usage: bun scripts/sync-format-ignore.ts
 */

import { $ } from "bun";
import { resolve } from "node:path";
import { log } from "./_utils/logs";

const repoRoot = resolve(import.meta.dir, "../..");

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

await Bun.write(resolve(repoRoot, "oxfmt.config.ts"), fileContent);
log.success(`Updated oxfmt.config.ts`);

// Treefmt - only need git submodules, follows .gitignore by default
const treefmtTemplate = resolve(import.meta.dir, "format-ignore-templates/treefmt.toml");
const treefmtText = await Bun.file(treefmtTemplate).text();
const treefmtEntries = submodulePaths.map((p) => `    "${p}",`).join("\n");
const treefmtContent = treefmtText.replace(/^\s*# \$MARKER\$/m, treefmtEntries);

await Bun.write(resolve(repoRoot, "treefmt.toml"), treefmtContent);
log.success(`Updated treefmt.toml`);

async function getModulesPaths(): Promise<string[]> {
  const gitmodulesPath = resolve(repoRoot, ".gitmodules");
  if (!(await Bun.file(gitmodulesPath).exists())) return [];

  const output = await $`git config --file .gitmodules --get-regexp ${"\\.path$"}`
    .cwd(repoRoot)
    .text();

  return output
    .trim()
    .split("\n")
    .filter(Boolean)
    .map((line) => line.split(/\s+/)[1]!);
}

async function getGitignorePatterns(): Promise<string[]> {
  const gitignorePath = resolve(repoRoot, ".gitignore");
  if (!(await Bun.file(gitignorePath).exists())) return [];

  const content = await Bun.file(gitignorePath).text();
  return content
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith("#"));
}

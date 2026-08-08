/**
 * Install npm dependencies for extension directories.
 * Uses npm if package-lock.json exists, bun otherwise.
 */

import { $ } from "bun";
import { existsSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { color, log, REPO_ROOT } from "./_utils/helpers";

type PackageManager = "bun" | "npm";

function detectPackageManager(dir: string): PackageManager {
  if (existsSync(resolve(dir, "bun.lock"))) return "bun";
  if (existsSync(resolve(dir, "package-lock.json"))) return "npm";
  return "bun";
}

const installActions: Record<PackageManager, string[]> = {
  bun: ["bun", "install", "--frozen-lockfile"],
  npm: ["npm", "ci"],
};

const files = await $`find \
    dotfiles/pi/.pi/agent/extensions \
    dotfiles/pi/.pi/pi-extensions \
    -maxdepth 2 -name 'package.json'`
  .cwd(REPO_ROOT)
  .nothrow()
  .text();

const packages = files.trim().split("\n").filter(Boolean);

if (packages.length === 0) {
  log.info("No extensions found.");
  process.exit(0);
}

const count = packages.length;
log.info(`Found ${count} extension${count === 1 ? "" : "s"}`);
console.log();

let failed = false;

for (const pkg of packages) {
  const dir = resolve(REPO_ROOT, dirname(pkg));
  const pm = detectPackageManager(dir);
  const name = dirname(pkg).split("/").pop()!;

  log.info(`${name} (${pm})`);

  try {
    await $`${installActions[pm]}`.cwd(dir).quiet();
    log.success(`${name} — installed`);
  } catch (err: any) {
    const output = (err.stdout || "") + (err.stderr || "");
    if (output.trim()) {
      console.log(
        color.red(
          output
            .trim()
            .split("\n")
            .map((l: string) => `    ${l}`)
            .join("\n"),
        ),
      );
    }
    log.error(`${name} — failed`);
    failed = true;
  }

  console.log();
}

if (failed) {
  log.error("Some extensions failed to install.");
  process.exit(1);
}

log.success("All extensions installed.");

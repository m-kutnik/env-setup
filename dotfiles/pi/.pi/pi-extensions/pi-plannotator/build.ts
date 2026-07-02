import { $ } from "bun";
import { parseArgs } from "util";

const SOURCE_DIR = "source";
const OUTPUT_DIR = "pi-plannotator";

const { values } = parseArgs({
  args: Bun.argv,
  options: {
    mode: {
      type: "string",
    },
  },
  allowPositionals: true,
});

const actions: Record<string, () => Promise<void>> = {
  install: async () => {
    await $`cd ${SOURCE_DIR} && bun install --frozen-lockfile`;
  },
  build: async () => {
    await $`cd ${SOURCE_DIR} && bun run build:pi`;
    await $`cp -r ${SOURCE_DIR}/apps/pi-extension ${OUTPUT_DIR}`;
    await $`cd ${SOURCE_DIR} && git restore .`;
    await $`cd ${OUTPUT_DIR} && bun install --frozen-lockfile`;
  },
};

const action = actions[values.mode || ""];
if (action) {
  await action();
} else {
  console.error(`Unknown mode: ${values.mode}. Use "install" or "build".`);
}

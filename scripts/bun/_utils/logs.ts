export const color = {
  red: (s: string) => `\x1b[0;31m${s}\x1b[0m`,
  green: (s: string) => `\x1b[0;32m${s}\x1b[0m`,
  yellow: (s: string) => `\x1b[1;33m${s}\x1b[0m`,
  blue: (s: string) => `\x1b[0;34m${s}\x1b[0m`,
};

export const log = {
  info: (...args: string[]) => console.log(`${color.blue("==>")} ${args.join(" ")}`),
  success: (...args: string[]) => console.log(`${color.green("==>")} ${args.join(" ")}`),
  warn: (...args: string[]) => console.log(`${color.yellow("==>")} ${args.join(" ")}`),
  error: (...args: string[]) => console.error(`${color.red("==>")} ${args.join(" ")}`),
};

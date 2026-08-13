#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

if is_darwin; then
  exec "$SCRIPT_DIR/darwin/uninstall.sh" "$@"
elif is_linux; then
  exec "$SCRIPT_DIR/linux/uninstall.sh" "$@"
else
  error "Unsupported OS: $OS"
  exit 1
fi

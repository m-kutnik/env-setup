#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

for f in "$SCRIPT_DIR"/system-defaults/*.sh; do
  bash "$f" "$@"
done

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

bw_unlock
for f in "$SCRIPT_DIR"/apply-defaults/*.sh; do
  bash "$f" "$@"
done
bw_lock

warn "Some apps may need to be restarted for changes to take effect.\n"

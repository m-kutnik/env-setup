#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

log "Restarting apps..."

killall Dock
killall Finder
killall SystemUIServer

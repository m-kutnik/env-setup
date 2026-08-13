#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"
require_linux

log "Linux bootstrap"

if ! command -v apt-get >/dev/null 2>&1; then
  error "Unsupported Linux distribution: apt-get is required"
  exit 1
fi

run sudo apt-get update
run sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  build-essential python3 sqlite3 zsh curl git wget jq unzip ca-certificates socat node-gyp

ZSH_PATH="$(command -v zsh)"
CURRENT_SHELL="$(getent passwd "$(whoami)" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
  log "Setting zsh as login shell..."
  run sudo chsh -s "$ZSH_PATH" "$(whoami)"
else
  skipped "zsh already login shell"
fi

success "Linux bootstrap complete"

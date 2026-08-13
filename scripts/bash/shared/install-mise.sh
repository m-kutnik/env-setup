#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

export PATH="$HOME/.local/bin:$PATH"

if ! command -v mise &>/dev/null; then
  log "Installing mise..."
  curl -fsSL https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
  if ! command -v mise &>/dev/null; then
    error "mise install failed"
    exit 1
  fi
  success "mise installed"
else
  skipped "mise already installed"
fi

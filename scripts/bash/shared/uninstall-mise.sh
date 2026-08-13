#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

if command -v mise &>/dev/null; then
  if confirm "Uninstall mise?"; then
    if confirm "Also remove global config directory (~/.config/mise)?"; then
      log "Imploding mise and removing config..."
      run mise implode --config -y
      success "mise and config removed."
    else
      log "Imploding mise (keeping config)..."
      run mise implode -y
      success "mise removed."
    fi
  else
    skipped "Skipping mise removal."
  fi
else
  skipped "mise not found."
fi

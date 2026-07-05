#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

log "Copying fonts to /Library/Fonts..."
sudo -Hu "$BREW_USER" bash -c 'cp ~/Library/Fonts/* /Library/Fonts/'

success "Fonts copied"

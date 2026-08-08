#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

"$SCRIPT_DIR/install-xcode.sh" "$@"
"$SCRIPT_DIR/setup-homebrew.sh" "$@"
"$SCRIPT_DIR/install-homebrew-base.sh" "$@"
"$SCRIPT_DIR/install-fonts.sh" "$@"
"$SCRIPT_DIR/setup-mise.sh" "$@"

log "Installing Pi"
run mise run install:pi

"$SCRIPT_DIR/install-homebrew-extras.sh" "$@"
"$SCRIPT_DIR/install-launchd-services.sh" "$@"
"$SCRIPT_DIR/apply-defaults.sh" "$@"
"$SCRIPT_DIR/restart-apps.sh" "$@"

success "Setup complete"

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

"$SCRIPT_DIR/xcode-install.sh" "$@"
"$SCRIPT_DIR/homebrew-setup.sh" "$@"
"$SCRIPT_DIR/homebrew-install-base.sh" "$@"
"$SCRIPT_DIR/repo-deps.sh" "$@"

log "Running mise bootstrap..."
run mise bootstrap --yes

log "Installing Pi"
bun add -g --ignore-scripts @earendil-works/pi-coding-agent

"$SCRIPT_DIR/homebrew-install-extras.sh" "$@"
"$SCRIPT_DIR/homebrew-install-mas.sh" "$@"
"$SCRIPT_DIR/apply-defaults.sh" "$@"
"$SCRIPT_DIR/restart-apps.sh" "$@"

success "Setup complete"

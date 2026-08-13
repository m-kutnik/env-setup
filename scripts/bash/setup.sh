#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

export PATH="$HOME/.local/bin:$PATH"

if is_darwin; then
  "$SCRIPT_DIR/darwin/install-xcode.sh" "$@"
  "$SCRIPT_DIR/darwin/setup-homebrew.sh" "$@"
  "$SCRIPT_DIR/darwin/install-homebrew-base.sh" "$@"
  "$SCRIPT_DIR/darwin/install-fonts.sh" "$@"
elif is_linux; then
  "$SCRIPT_DIR/linux/bootstrap.sh" "$@"
else
  error "Unsupported OS: $OS"
  exit 1
fi

"$SCRIPT_DIR/shared/install-mise.sh" "$@"
"$SCRIPT_DIR/shared/setup-mise.sh" "$@"
export PATH="${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims:$PATH"

log "Installing Pi"
run mise run install:pi

if is_darwin; then
  "$SCRIPT_DIR/darwin/install-homebrew-extras.sh" "$@"
  "$SCRIPT_DIR/darwin/install-launchd-services.sh" "$@"
  "$SCRIPT_DIR/darwin/apply-defaults.sh" "$@"
  "$SCRIPT_DIR/darwin/restart-apps.sh" "$@"
fi

success "Setup complete"

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

BREWFILE="$REPO_ROOT/brew/Brewfile.extras"

if sudo -Hu "$BREW_USER" brew bundle check --file="$BREWFILE" &>/dev/null; then
  skipped "All Brewfile extras already installed."
else
  log "Installing Brewfile extras..."
  sudo -Hu "$BREW_USER" brew bundle install --file="$BREWFILE"
  success "Brewfile extras installed."
fi

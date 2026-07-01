#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

BREWFILE="$REPO_ROOT/brew/Brewfile.base"

if sudo -Hu "$BREW_USER" brew bundle check --file="$BREWFILE" &>/dev/null; then
  skipped "All Brewfile dependencies already installed."
else
  log "Installing Brewfile dependencies..."
  sudo -Hu "$BREW_USER" brew bundle install --file="$BREWFILE"
  success "Brewfile dependencies installed."
fi

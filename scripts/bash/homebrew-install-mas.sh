#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

BREWFILE="$REPO_ROOT/brew/Brewfile.mas"

if sudo -Hu "$BREW_USER" brew bundle check --file="$BREWFILE" &>/dev/null; then
  skipped "All Brewfile mas apps already installed."
else
  log "Installing Brewfile mas apps..."
  warn "It may ask you for your password, or to log in to the App Store."
  sudo -Hu "$BREW_USER" brew bundle install --file="$BREWFILE"
  success "Brewfile mas apps installed."
fi

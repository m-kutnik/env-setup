#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

BREWFILE="$REPO_ROOT/brew/Brewfile.repo-dev"

if sudo -Hu "$BREW_USER" brew bundle check --file="$BREWFILE" &>/dev/null; then
  skipped "All Brewfile repo dependencies already installed."
else
  log "Installing Brewfile repo dependencies..."
  sudo -Hu "$BREW_USER" brew bundle install --file="$BREWFILE"
  success "Brewfile repo dependencies installed."
fi

cd "$REPO_ROOT"
run bun install

mise trust
mise settings experimental=true

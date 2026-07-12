#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

"$SCRIPT_DIR/xcode-install.sh" "$@"
"$SCRIPT_DIR/homebrew-setup.sh" "$@"
"$SCRIPT_DIR/homebrew-install-base.sh" "$@"
"$SCRIPT_DIR/install-fonts.sh" "$@"

log "Running mise bootstrap..."

MISE_CONFIG_SRC="$REPO_ROOT/dotfiles/mise/.config/mise"
MISE_CONFIG_DST="$HOME/.config/mise"

if [ -e "$MISE_CONFIG_DST" ] || [ -L "$MISE_CONFIG_DST" ]; then
  if ! [ -L "$MISE_CONFIG_DST" ] || [ "$(readlink "$MISE_CONFIG_DST")" != "$MISE_CONFIG_SRC" ]; then
    warn "$MISE_CONFIG_DST already exists and is not a symlink to $MISE_CONFIG_SRC"
    if confirm "Overwrite with symlink to $MISE_CONFIG_SRC?"; then
      run rm -rf "$MISE_CONFIG_DST"
      run ln -s "$MISE_CONFIG_SRC" "$MISE_CONFIG_DST"
      log-secondary "Mise config symlinked"
    fi
  fi
else
  run ln -s "$MISE_CONFIG_SRC" "$MISE_CONFIG_DST"
fi

run mise settings experimental=true
run mise trust
run mise deps

run mise bootstrap --yes

log "Installing Pi"
run bun add -g --ignore-scripts @earendil-works/pi-coding-agent

"$SCRIPT_DIR/homebrew-install-extras.sh" "$@"
"$SCRIPT_DIR/homebrew-install-mas.sh" "$@"
"$SCRIPT_DIR/install-launchd-services.sh" "$@"
"$SCRIPT_DIR/apply-defaults.sh" "$@"
"$SCRIPT_DIR/restart-apps.sh" "$@"

success "Setup complete"

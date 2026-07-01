#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

if ! dscl . -read "/Groups/$BREW_GROUP" &>/dev/null; then
  log "Creating $BREW_GROUP group..."
  run sudo dseditgroup -o create -r 'Homebrew group' "$BREW_GROUP"
  success "$BREW_GROUP group created."
else
  skipped "$BREW_GROUP group already exists."
fi

if ! id -u "$BREW_USER" &>/dev/null; then
  log "Creating $BREW_USER user..."
  run sudo sysadminctl -addUser "$BREW_USER" -fullName 'Homebrew' -admin -home "$BREW_HOME" -UID 2137 -shell /bin/bash
  # run sudo createhomedir -c -u "$BREW_USER"
  run sudo mkdir -p "$BREW_HOME"
  run sudo chown "$BREW_USER":"$BREW_GROUP" "$BREW_HOME"
  run sudo dscl . -create "/Users/$BREW_USER" IsHidden 1
  success "$BREW_USER user created."
else
  skipped "$BREW_USER user already exists."
fi

if ! dscl . -read "/Groups/$BREW_GROUP" GroupMembership 2>/dev/null | grep -qw "$(whoami)"; then
  log "Adding current user ($(whoami)) to the $BREW_GROUP group."
  run sudo dseditgroup -o edit -a "$(whoami)" -t user "$BREW_GROUP"
else
  skipped "Current user already in $BREW_GROUP group."
fi

if [ ! -f "$BREW_SUDOERS_FILE" ]; then
  log "Installing brew sudoers file..."
  run sudo visudo -c -s -f "$BREW_SUDOERS_SRC"
  run sudo cp "$BREW_SUDOERS_SRC" "$BREW_SUDOERS_FILE"
  run sudo chown root:wheel "$BREW_SUDOERS_FILE"
  run sudo chmod 440 "$BREW_SUDOERS_FILE"
  success "brew sudoers file installed."
else
  skipped "brew sudoers file already exists."
fi

if [ ! -f "$BREW_BASHRC_DST" ]; then
  log "Installing brew user .bashrc..."
  run sudo cp "$BREW_BASHRC_SRC" "$BREW_BASHRC_DST"
  run sudo chown "$BREW_USER:admin" "$BREW_BASHRC_DST"
  success "brew user .bashrc installed."
else
  skipped "brew user .bashrc already exists."
fi

if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  success "Homebrew installed."
else
  skipped "Homebrew already installed."
fi

HOMEBREW_PREFIX=$(brew --prefix)

if ! sudo -u "$BREW_USER" test -w "$HOMEBREW_PREFIX" 2>/dev/null; then
  log "Fixing $HOMEBREW_PREFIX ownership..."
  run sudo chown -R "$BREW_USER:admin" "$HOMEBREW_PREFIX"
  success "$HOMEBREW_PREFIX ownership fixed."
else
  skipped "$HOMEBREW_PREFIX already owned by $BREW_USER."
fi

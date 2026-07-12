#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

if command -v brew &>/dev/null; then
  HOMEBREW_PREFIX=$(brew --prefix)
else
  HOMEBREW_PREFIX=$([[ $(uname -m) == "arm64" ]] && echo /opt/homebrew || echo /usr/local)
fi

if command -v mise &>/dev/null; then
  if confirm "Uninstall mise?"; then
    if confirm "Also remove global config directory (~/.config/mise)?"; then
      log "Imploding mise and removing config..."
      run mise implode --config -y
      success "mise and config removed."
    else
      log "Imploding mise (keeping config)..."
      runmise implode -y
      success "mise removed."
    fi
  else
    skipped "Skipping mise removal."
  fi
fi

if confirm "Remove Homebrew and all related configuration?"; then
  if command -v brew &>/dev/null; then
    log "Uninstalling Homebrew..."
    sudo -u "$BREW_USER" NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh | sed 's/execute_sudo \/usr\/bin\/find/\/usr\/bin\/find/g')"
    success "Homebrew uninstalled."
  else
    skipped "Homebrew not found."
  fi

  if [ -f $BREW_PATHS_FILE ]; then
    log "Removing $BREW_PATHS_FILE..."
    run sudo rm $BREW_PATHS_FILE
    success "$BREW_PATHS_FILE removed."
  else
    skipped "$BREW_PATHS_FILE not found."
  fi

  if [ -f "$BREW_SUDOERS_FILE" ]; then
    log "Removing brew sudoers file..."
    run sudo rm "$BREW_SUDOERS_FILE"
    success "brew sudoers file removed."
  else
    skipped "brew sudoers file not found."
  fi

  if id -u "$BREW_USER" &>/dev/null; then
    log "Removing $BREW_USER user..."
    run sudo sysadminctl -deleteUser "$BREW_USER" -secure
    success "$BREW_USER user removed."
  else
    skipped "$BREW_USER user not found."
  fi

  if [ -d "$BREW_HOME" ]; then
    log "Removing $BREW_HOME..."
    run sudo rm -rf "$BREW_HOME"
    success "$BREW_HOME removed."
  else
    skipped "$BREW_HOME not found."
  fi

  if dscl . -read "/Groups/$BREW_GROUP" &>/dev/null; then
    log "Removing $BREW_GROUP group..."
    run sudo dseditgroup -o delete "$BREW_GROUP"
    success "$BREW_GROUP group removed."
  else
    skipped "$BREW_GROUP group not found."
  fi

  if [ -d "$HOMEBREW_PREFIX" ]; then
    log "Removing $HOMEBREW_PREFIX..."
    run sudo rm -rf "$HOMEBREW_PREFIX"
    success "$HOMEBREW_PREFIX removed."
  else
    skipped "$HOMEBREW_PREFIX not found."
  fi

  success "Homebrew removed."
else
  skipped "Skipping Homebrew removal."
fi

if confirm "Remove env-setup launchd services?"; then
  # Unload all env-setup services
  sudo launchctl print system 2>/dev/null | grep -oE 'env-setup\.[[:alnum:]_.-]+' | sort -u | while read -r service_name; do
    service_target="system/$service_name"
    log "Unloading $service_target..."
    if sudo launchctl bootout "$service_target" 2>/dev/null; then
      success "Unloaded $service_target."
    else
      skipped "$service_target not loaded."
    fi
  done

  # Remove plist files
  for plist in /Library/LaunchDaemons/env-setup.*.plist; do
    [ -f "$plist" ] || continue
    log "Removing $plist..."
    run sudo rm "$plist"
    success "Removed $plist."
  done

  # Remove bin directory
  if [ -d "$BIN_DIR" ]; then
    log "Removing $BIN_DIR..."
    run sudo rm -rf "$BIN_DIR"
    success "$BIN_DIR removed."
  else
    skipped "$BIN_DIR not found."
  fi

  # Remove log directory
  if [ -d "$LOG_DIR" ]; then
    log "Removing $LOG_DIR..."
    run sudo rm -rf "$LOG_DIR"
    success "$LOG_DIR removed."
  else
    skipped "$LOG_DIR not found."
  fi

  # Remove newsyslog config
  if [ -f "$NEWSYSLOG_CONF" ]; then
    log "Removing $NEWSYSLOG_CONF..."
    run sudo rm "$NEWSYSLOG_CONF"
    success "$NEWSYSLOG_CONF removed."
  else
    skipped "$NEWSYSLOG_CONF not found."
  fi

  success "Launchd services removed."
else
  skipped "Skipping launchd services removal."
fi

success "Uninstall complete."

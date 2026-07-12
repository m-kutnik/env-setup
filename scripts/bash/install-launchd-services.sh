#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

SYSTEM_DAEMONS_DIR="/Library/LaunchDaemons"

log "Installing launchd services..."

# Ensure log directory exists
if [ ! -d "$LOG_DIR" ]; then
  log-secondary "Creating log directory..."
  run sudo mkdir -p "$LOG_DIR"
  run sudo chown root:wheel "$LOG_DIR"
  run sudo chmod 755 "$LOG_DIR"
fi

# Ensure env-setup bin directory exists
if [ ! -d "$BIN_DIR" ]; then
  log-secondary "Creating bin directory..."
  run sudo mkdir -p "$BIN_DIR"
  run sudo chown root:wheel "$BIN_DIR"
  run sudo chmod 755 "$BIN_DIR"
fi

# Install newsyslog config for log rotation
NEWSYSLOG_SRC="$REPO_ROOT/launchd/newsyslog/env-setup.conf"
log "Installing newsyslog config..."
run sudo cp "$NEWSYSLOG_SRC" "$NEWSYSLOG_CONF"
run sudo chmod 644 "$NEWSYSLOG_CONF"
log-secondary "Installed $NEWSYSLOG_CONF"

# Build fda-launcher
"$SCRIPT_DIR/build-fda-launcher.sh"

for daemon_dir in "$LAUNCHD_SYSTEM_DAEMONS_SOURCE_DIR"/*; do
  [ -d "$daemon_dir" ] || continue

  daemon_name="$(basename "$daemon_dir")"
  bin_file="$daemon_dir/bin.sh"
  plist_file="$daemon_dir/service.plist"

  if [ ! -f "$bin_file" ]; then
    warn "Skipping $daemon_name: no bin file found"
    continue
  fi

  if [ ! -f "$plist_file" ]; then
    warn "Skipping $daemon_name: no service.plist found"
    continue
  fi

  log "Installing $daemon_name..."

  # Copy and install bin file
  run sudo cp "$bin_file" "$BIN_DIR/$daemon_name"
  run sudo chmod 755 "$BIN_DIR/$daemon_name"
  run sudo chown root:wheel "$BIN_DIR/$daemon_name"
  log-secondary "Installed $BIN_DIR/$daemon_name"

  # Install plist
  run sudo cp "$plist_file" "$SYSTEM_DAEMONS_DIR/env-setup.$daemon_name.plist"
  run sudo chmod 644 "$SYSTEM_DAEMONS_DIR/env-setup.$daemon_name.plist"
  run sudo chown root:wheel "$SYSTEM_DAEMONS_DIR/env-setup.$daemon_name.plist"
  log-secondary "Installed $SYSTEM_DAEMONS_DIR/env-setup.$daemon_name.plist"

  # Bootstrap or kickstart the service
  service_target="system/env-setup.$daemon_name"
  if sudo launchctl print "$service_target" &>/dev/null; then
    run sudo launchctl kickstart -k "$service_target"
    log-secondary "Restarted service env-setup.$daemon_name"
  else
    run sudo launchctl bootstrap system "$SYSTEM_DAEMONS_DIR/env-setup.$daemon_name.plist"
    run sudo launchctl enable "$service_target"
    run sudo launchctl kickstart -k "$service_target"
    log-secondary "Started service env-setup.$daemon_name"
  fi
done

success "Launchd daemons installed"

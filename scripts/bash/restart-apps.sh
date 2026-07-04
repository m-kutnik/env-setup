#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

log "Restarting system services..."

killall Dock
killall Finder
killall SystemUIServer

success "System services restarted."

# Apps to start if not running (e.g. launchers, utilities)
APPS_TO_START=(
  "Raycast"
)

# Apps to restart so they pick up new defaults/initialize after setup
APPS_TO_RESTART=(
  "AlDente"
  "Macs Fan Control"
  "Ice"
)

log "Starting required apps..."
for app in "${APPS_TO_START[@]}"; do
  if ! pgrep -xq "$app"; then
    log-secondary "Launching $app..."
    open -a "$app"
  else
    skipped "$app is already running."
  fi
done

log "Restarting apps..."
for app in "${APPS_TO_RESTART[@]}"; do
  if pgrep -xq "$app"; then
    log-secondary "Restarting $app..."
    killall "$app" 2>/dev/null || true
    sleep 1
    open -a "$app"
  else
    log-secondary "Launching $app..."
    open -a "$app"
  fi
done

success "Apps restarted."

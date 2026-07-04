#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting Macs Fan Control defaults"
APP="com.crystalidea.macsfancontrol"

defaults_write_if_absent "$APP" CustomPresets -array "QmF0dGVyeXwyLFRCMFQsMjgsMzZ8MixUQjBULDI4LDM2"
defaults_write_if_absent "$APP" DockIcon -int 0
defaults_write_if_absent "$APP" Fahrenheit -int 0
defaults_write_if_absent "$APP" menubarIcon -int 2

defaults_write_if_absent_authenticated "$APP" License -string "macs-fan-control-plist"

success "Macs Fan Control defaults set"
unset APP

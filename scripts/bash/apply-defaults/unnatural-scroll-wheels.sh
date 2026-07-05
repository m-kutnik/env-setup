#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting UnnaturalScrollWheels defaults"
APP="com.theron.UnnaturalScrollWheels"

# Scroll Behavior
defaults_write_if_absent "$APP" InvertVerticalScroll -int 1
defaults_write_if_absent "$APP" InvertHorizontalScroll -int 0
defaults_write_if_absent "$APP" ScrollLines -int 3

# Acceleration
defaults_write_if_absent "$APP" DisableScrollAccel -int 1
defaults_write_if_absent "$APP" DisableMouseAccel -int 1

# Detection
defaults_write_if_absent "$APP" AlternateDetectionMethod -int 0

# Launch & Appearance
defaults_write_if_absent "$APP" LaunchAtLogin -int 1
defaults_write_if_absent "$APP" ShowMenuBarIcon -int 0

success "UnnaturalScrollWheels defaults set"
unset APP

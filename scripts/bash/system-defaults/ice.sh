#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting Ice defaults"
APP="com.jordanbaird.Ice"

# Appearance
defaults_write_if_absent "$APP" ShowIceIcon -int 0
defaults_write_if_absent "$APP" CustomIceIconIsTemplate -int 0
defaults_write_if_absent "$APP" SectionDividerStyle -int 1
defaults_write_if_absent "$APP" ItemSpacingOffset -string "-8"

# Behavior
defaults_write_if_absent "$APP" AutoRehide -int 1
defaults_write_if_absent "$APP" RehideStrategy -int 0
defaults_write_if_absent "$APP" RehideInterval -int 15
defaults_write_if_absent "$APP" TempShowInterval -int 15
defaults_write_if_absent "$APP" ShowOnClick -int 1
defaults_write_if_absent "$APP" ShowOnHover -int 0
defaults_write_if_absent "$APP" ShowOnHoverDelay -string "0.2"
defaults_write_if_absent "$APP" ShowOnScroll -int 0
defaults_write_if_absent "$APP" ShowAllSectionsOnUserDrag -int 1

# Sections
defaults_write_if_absent "$APP" EnableAlwaysHiddenSection -int 1
defaults_write_if_absent "$APP" CanToggleAlwaysHiddenSection -int 1
defaults_write_if_absent "$APP" HideApplicationMenus -int 1

# Menu Bar / Ice Bar
defaults_write_if_absent "$APP" UseIceBar -int 0
defaults_write_if_absent "$APP" IceBarLocation -int 0

# Context Menu
defaults_write_if_absent "$APP" EnableSecondaryContextMenu -int 1

# Updates (Sparkle)
defaults_write_if_absent "$APP" SUAutomaticallyUpdate -int 1
defaults_write_if_absent "$APP" SUEnableAutomaticChecks -int 1
defaults_write_if_absent "$APP" SUSendProfileInfo -int 0

success "Ice defaults set"
unset APP

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting AlDente Pro defaults"
APP="com.apphousekitchen.aldente-pro"

# Charging
defaults_write_if_absent "$APP" chargeVal -int 70
defaults_write_if_absent "$APP" automaticDischarge -int 1
defaults_write_if_absent "$APP" sailingMode -int 1
defaults_write_if_absent "$APP" sailingLevel -int 10
defaults_write_if_absent "$APP" exitInhibitCharge -int 0
defaults_write_if_absent "$APP" sleepInhibitCharge -int 0

# Heat Protection
defaults_write_if_absent "$APP" heatProtectMode -int 1
defaults_write_if_absent "$APP" maxTemperature -int 35

# Energy Mode
defaults_write_if_absent "$APP" onBatteryEnergyMode -int 0
defaults_write_if_absent "$APP" onPowerAdapterEnergyMode -int 0

# Menu Bar
defaults_write_if_absent "$APP" showPercentage -int 1
defaults_write_if_absent "$APP" noMenubarIcon -int 0
defaults_write_if_absent "$APP" menuBarIconStyle -int 1
defaults_write_if_absent "$APP" menubarItemSpacing -int 5
defaults_write_if_absent "$APP" menubarItemUpdateInterval -int 5
defaults_write_if_absent "$APP" menubarRightClickAction -int 2
defaults_write_if_absent "$APP" showDockIcon -int 0

# Appearance
defaults_write_if_absent "$APP" accentColor -int 0
defaults_write_if_absent "$APP" colorMode -int 2
defaults_write_if_absent "$APP" reduceTransparency -int 0
defaults_write_if_absent "$APP" popoverAnimation -int 0

# Sleep / Clamshell
defaults_write_if_absent "$APP" completelyDisableSleep -int 0
defaults_write_if_absent "$APP" lockScreenWhenClosed -int 0
defaults_write_if_absent "$APP" displayOffWhenSleepDisabled -int 1

# Launch
defaults_write_if_absent "$APP" launchAtLogin -int 1
defaults_write_if_absent "$APP" showGUIonStartup -int 0

# Calibration
defaults_write_if_absent "$APP" calibrationBackupPercentage -int 70

# Privacy
defaults_write_if_absent "$APP" dataShareConsent -int 0

# Updates
defaults_write_if_absent "$APP" SUAutomaticallyUpdate -int 1
defaults_write_if_absent "$APP" SUEnableAutomaticChecks -int 1
defaults_write_if_absent "$APP" SUSendProfileInfo -int 0

success "AlDente Pro defaults set"
unset APP

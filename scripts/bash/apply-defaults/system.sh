#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting MacOS defaults"

# Dock
log "Setting Dock defaults"
APP="com.apple.dock"
defaults_write_if_absent "$APP" autohide -int 1
defaults_write_if_absent "$APP" show-recents -int 0
defaults_write_if_absent "$APP" tilesize -int 40
defaults_write_if_absent "$APP" mru-spaces -int 0
defaults_write_if_absent "$APP" show-process-indicators -int 0
defaults_write_if_absent "$APP" static-only -int 1
defaults_write_if_absent "$APP" launchanim -int 0
defaults_write_if_absent "$APP" wvous-br-corner -int 1
defaults_write_if_absent "$APP" wvous-tl-corner -int 1
defaults_write_if_absent "$APP" wvous-tr-corner -int 1
defaults_write_if_absent "$APP" wvous-bl-corner -int 1
unset APP

# Finder
log "Setting Finder defaults"
APP="com.apple.finder"
defaults_write_if_absent "$APP" AppleShowAllFiles -int 1
defaults_write_if_absent "$APP" ShowStatusBar -int 0
defaults_write_if_absent "$APP" ShowSidebar -int 1
defaults_write_if_absent "$APP" ShowPathbar -int 1
defaults_write_if_absent "$APP" ShowExtensionChangeWarning -int 0
defaults_write_if_absent "$APP" AppleShowAllExtensions -int 1
defaults_write_if_absent "$APP" CreateDesktop -int 0
defaults_write_if_absent "$APP" FXDefaultSearchScope -string "SCcf"
defaults_write_if_absent "$APP" NewWindowTarget -string "Home"
defaults_write_if_absent "$APP" ShowExternalHardDrivesOnDesktop -int 0
defaults_write_if_absent "$APP" ShowHardDrivesOnDesktop -int 0
defaults_write_if_absent "$APP" ShowMountedServersOnDesktop -int 0
defaults_write_if_absent "$APP" ShowRemovableMediaOnDesktop -int 0
defaults_write_if_absent "$APP" _FXShowPosixPathInTitle -int 1
defaults_write_if_absent "$APP" _FXSortFoldersFirst -int 1
defaults_write_if_absent "$APP" SidebarWidth -int 159
defaults_write_if_absent "$APP" SidebarWidth2 -int 159
unset APP

# Keyboard
log "Setting keyboard defaults"
defaults_write_if_absent NSGlobalDomain com.apple.keyboard.fnState -int 1

# NSGlobalDomain
log "Setting NSGlobalDomain defaults"
defaults_write_if_absent NSGlobalDomain com.apple.sound.beep.feedback -int 1
defaults_write_if_absent NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults_write_if_absent NSGlobalDomain NSAutomaticCapitalizationEnabled -int 0
defaults_write_if_absent NSGlobalDomain NSAutomaticDashSubstitutionEnabled -int 0
defaults_write_if_absent NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -int 0
defaults_write_if_absent NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -int 0
defaults_write_if_absent NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -int 0
defaults_write_if_absent NSGlobalDomain com.apple.mouse.linear -int 1
defaults_write_if_absent NSGlobalDomain AppleSpacesSwitchOnActivate -int 1

# Trackpad
log "Setting Trackpad defaults"
defaults_write_if_absent com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1
defaults_write_if_absent com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 1

# LaunchServices
log "Setting LaunchServices defaults"
defaults_write_if_absent com.apple.LaunchServices LSQuarantine -int 0

# Control Center
log "Setting Control Center defaults"
defaults_write_if_absent com.apple.controlcenter BatteryShowPercentage -int 0
defaults_write_if_absent com.apple.controlcenter NowPlaying -int 0

# Login Window
log "Setting Login Window defaults"
defaults_write_if_absent com.apple.loginwindow GuestEnabled -int 0
defaults_write_if_absent com.apple.loginwindow DisableConsoleAccess -int 1

# Fn key behavior
log "Setting Fn key defaults"
defaults_write_if_absent com.apple.hitoolbox AppleFnUsageType -string "Do Nothing"

# Screen Capture
log "Setting Screen Capture defaults"
defaults_write_if_absent com.apple.screencapture include-date -int 0
defaults_write_if_absent com.apple.screencapture save-selections -int 0
defaults_write_if_absent com.apple.screencapture target -string "clipboard"

# Startup chime off
log "Setting Accessibility defaults"
defaults_write_if_absent com.apple.Accessibility StartupSoundEnabled -int 0

success "System defaults set"

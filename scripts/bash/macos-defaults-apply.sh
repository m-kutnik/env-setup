#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

log "Configuring macOS defaults..."

# Dock
run defaults write com.apple.dock autohide -bool true
run defaults write com.apple.dock show-recents -bool false
run defaults write com.apple.dock tilesize -int 40
run defaults write com.apple.dock mru-spaces -bool false
run defaults write com.apple.dock show-process-indicators -bool true
run defaults write com.apple.dock static-only -bool true
run defaults write com.apple.dock launchanim -bool false
run defaults write com.apple.dock wvous-br-corner -int 1
run defaults write com.apple.dock wvous-tl-corner -int 1
run defaults write com.apple.dock wvous-tr-corner -int 1
run defaults write com.apple.dock wvous-bl-corner -int 1

# Finder
run defaults write com.apple.finder AppleShowAllFiles -bool true
run defaults write com.apple.finder AppleShowAllExtensions -bool true
run defaults write com.apple.finder ShowStatusBar -bool false
run defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
run defaults write com.apple.finder CreateDesktop -bool false
run defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
run defaults write com.apple.finder NewWindowTarget -string "Home"
run defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
run defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
run defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
run defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
run defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
run defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Global
run defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
run defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 1
run defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
run defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
run defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
run defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
run defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
run defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
run defaults write NSGlobalDomain com.apple.mouse.linear -bool true

# Trackpad
run defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true
run defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -bool true

# Launch Services
run defaults write com.apple.LaunchServices LSQuarantine -bool false

# Control Center
run defaults write com.apple.controlcenter BatteryShowPercentage -bool false
run defaults write com.apple.controlcenter NowPlaying -bool false

# Login Window
run defaults write com.apple.loginwindow GuestEnabled -bool false
run defaults write com.apple.loginwindow DisableConsoleAccess -bool true

# Hitoolbox
run defaults write com.apple.hitoolbox AppleFnUsageType -string "Do Nothing"

# Screen Capture
run defaults write com.apple.screencapture include-date -bool false
run defaults write com.apple.screencapture save-selections -bool false
run defaults write com.apple.screencapture target -string "clipboard"

# Accessibility
run defaults write com.apple.Accessibility StartupSoundEnabled -bool false

# Restart affected apps
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

success "macOS defaults applied"

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../../_utils/helpers.sh"

log "Setting MacOS defaults"

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
run osascript -e 'tell application "System Preferences" to quit'

# Dock
defaults_write_if_absent com.apple.dock autohide -int 1
defaults_write_if_absent com.apple.dock show-recents -int 0
defaults_write_if_absent com.apple.dock tilesize -int 40
defaults_write_if_absent com.apple.dock mru-spaces -int 0
defaults_write_if_absent com.apple.dock show-process-indicators -int 0
defaults_write_if_absent com.apple.dock static-only -int 1
defaults_write_if_absent com.apple.dock launchanim -int 0
defaults_write_if_absent com.apple.dock wvous-br-corner -int 1
defaults_write_if_absent com.apple.dock wvous-tl-corner -int 1
defaults_write_if_absent com.apple.dock wvous-tr-corner -int 1
defaults_write_if_absent com.apple.dock wvous-bl-corner -int 1

# Finder
defaults_write_if_absent com.apple.finder AppleShowAllFiles -int 1
defaults_write_if_absent com.apple.finder ShowStatusBar -int 0
defaults_write_if_absent com.apple.finder ShowSidebar -int 1
defaults_write_if_absent com.apple.finder ShowPathbar -int 1
defaults_write_if_absent com.apple.finder ShowExtensionChangeWarning -int 0
defaults_write_if_absent com.apple.finder AppleShowAllExtensions -int 1
defaults_write_if_absent com.apple.finder CreateDesktop -int 0
defaults_write_if_absent com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults_write_if_absent com.apple.finder NewWindowTarget -string "Home"
defaults_write_if_absent com.apple.finder ShowExternalHardDrivesOnDesktop -int 0
defaults_write_if_absent com.apple.finder ShowHardDrivesOnDesktop -int 0
defaults_write_if_absent com.apple.finder ShowMountedServersOnDesktop -int 0
defaults_write_if_absent com.apple.finder ShowRemovableMediaOnDesktop -int 0
defaults_write_if_absent com.apple.finder _FXShowPosixPathInTitle -int 1
defaults_write_if_absent com.apple.finder _FXSortFoldersFirst -int 1
defaults_write_if_absent com.apple.finder SidebarWidth -int 159
defaults_write_if_absent com.apple.finder SidebarWidth2 -int 159
defaults_write_if_absent com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keyboard
defaults_write_if_absent NSGlobalDomain com.apple.keyboard.fnState -int 1

# NSGlobalDomain
defaults_write_if_absent NSGlobalDomain com.apple.sound.beep.feedback -int 1
defaults_write_if_absent NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults_write_if_absent NSGlobalDomain NSAutomaticCapitalizationEnabled -int 0
defaults_write_if_absent NSGlobalDomain NSAutomaticDashSubstitutionEnabled -int 0
defaults_write_if_absent NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -int 0
defaults_write_if_absent NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -int 0
defaults_write_if_absent NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -int 0
defaults_write_if_absent NSGlobalDomain com.apple.mouse.linear -int 1
defaults_write_if_absent NSGlobalDomain AppleSpacesSwitchOnActivate -int 1
defaults_write_if_absent NSGlobalDomain AppleMiniaturizeOnDoubleClick -int 0
defaults_write_if_absent NSGlobalDomain AppleActionOnDoubleClick -string Maximize

# Trackpad
defaults_write_if_absent com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1
defaults_write_if_absent com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 1

# LaunchServices
defaults_write_if_absent com.apple.LaunchServices LSQuarantine -int 0

# Control Center
defaults_write_if_absent com.apple.controlcenter BatteryShowPercentage -int 0
defaults_write_if_absent com.apple.controlcenter NowPlaying -int 0

# Login Window
defaults_write_if_absent com.apple.loginwindow GuestEnabled -int 0
defaults_write_if_absent com.apple.loginwindow DisableConsoleAccess -int 1

# Fn key behavior
defaults_write_if_absent com.apple.hitoolbox AppleFnUsageType -string "Do Nothing"

# Screen Capture
defaults_write_if_absent com.apple.screencapture include-date -int 0
defaults_write_if_absent com.apple.screencapture save-selections -int 0
defaults_write_if_absent com.apple.screencapture target -string "clipboard"

# Startup chime off
defaults_write_if_absent com.apple.Accessibility StartupSoundEnabled -int 0

# Require password immediately after sleep or screen saver begins
defaults_write_if_absent com.apple.screensaver askForPassword -int 1
defaults_write_if_absent com.apple.screensaver askForPasswordDelay -int 0

# Avoid creating .DS_Store files on network or USB volumes
defaults_write_if_absent com.apple.desktopservices DSDontWriteNetworkStores -int 1
defaults_write_if_absent com.apple.desktopservices DSDontWriteUSBStores -int 1

# Enable snap-to-grid for icons on the desktop and in other icon views
run /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
run /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
run /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

success "System defaults set"

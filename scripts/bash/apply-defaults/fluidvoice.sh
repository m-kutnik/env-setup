#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting FluidVoice defaults"
APP="com.FluidApp.app"

# Launch & Dock
defaults_write_if_absent "$APP" LaunchAtStartup -int 1
defaults_write_if_absent "$APP" ShowInDock -int 0
defaults_write_if_absent "$APP" IntendedDockVisibility -int 0
defaults_write_if_absent "$APP" ShowMainWindowAtLoginLaunch -int 0
defaults_write_if_absent "$APP" PressAndHoldMode -int 1

# Overlay
defaults_write_if_absent "$APP" OverlaySize -string "small"
defaults_write_if_absent "$APP" OverlayBottomOffset -int 50

# Appearance
defaults_write_if_absent "$APP" AccentColorOption -string "Cyan"

# Dictation
defaults_write_if_absent "$APP" SelectedDictationPromptID -string "__FLUID_1__"
defaults_write_if_absent "$APP" DictationPromptOff -int 0
defaults_write_if_absent "$APP" SecondaryDictationPromptOff -int 1
defaults_write_if_absent "$APP" PauseMediaDuringTranscription -int 1
defaults_write_if_absent "$APP" SaveTranscriptionHistory -int 0
defaults_write_if_absent "$APP" TranscriptionStartSound -string "fluid_sfx_4"
defaults_write_if_absent "$APP" TranscriptionSoundVolume -string "0.05"

# AI & Model
defaults_write_if_absent "$APP" SelectedProviderID -string "fluid-1"
defaults_write_if_absent "$APP" FluidIntelligenceSelectedModelID -string "fluid-1"
defaults_write_if_absent "$APP" SelectedSpeechModel -string "parakeet-tdt"
defaults_write_if_absent "$APP" ParakeetFinalizationMode -string "stableFullFinal"
defaults_write_if_absent "$APP" VocabularyBoostingEnabled -int 0

# Text Processing (Grammar & Auto-correct)
defaults_write_if_absent "$APP" GAAVLowercaseFirstLetterEnabled -int 1
defaults_write_if_absent "$APP" GAAVRemoveTrailingPeriodEnabled -int 1
defaults_write_if_absent "$APP" TextInsertionMode -string "standard"

# Shortcuts
defaults_write_if_absent "$APP" CommandModeShortcutEnabled -int 0
defaults_write_if_absent "$APP" CommandModeConfirmBeforeExecute -int 1
defaults_write_if_absent "$APP" PromptModeShortcutEnabled -int 0

# Onboarding
defaults_write_if_absent "$APP" OnboardingCompleted -int 1
defaults_write_if_absent "$APP" OnboardingCurrentStep -int 5
defaults_write_if_absent "$APP" OnboardingGeneration -int 2
defaults_write_if_absent "$APP" OnboardingSelectedLanguageID -string "en"
defaults_write_if_absent "$APP" OnboardingAISkipped -int 0
defaults_write_if_absent "$APP" OnboardingPlaygroundSkipped -int 0
defaults_write_if_absent "$APP" OnboardingPlaygroundValidated -int 1
defaults_write_if_absent "$APP" PlaygroundUsed -int 1

success "FluidVoice defaults set"
unset APP

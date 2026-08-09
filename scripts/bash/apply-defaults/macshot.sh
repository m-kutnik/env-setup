#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting Macshot defaults"
APP="com.sw33tlie.macshot.macshot"

# Behavior
defaults_write_if_absent "$APP" quickCaptureMode -int 1
defaults_write_if_absent "$APP" windowSnapEnabled -int 0
defaults_write_if_absent "$APP" ocrAction -int 0

# Hotkey slot numbers:
#   1 = Capture Area       (keyCode key: hotkeyKeyCode,       modifiers key: hotkeyModifiers)
#   2 = Capture Screen     (keyCode key: hotkeyFullScreenKeyCode, modifiers key: hotkeyFullScreenModifiers)
#   3 = Record Area        (keyCode key: hotkeyRecordKeyCode, modifiers key: hotkeyRecordModifiers)
#   4 = Record Screen      (keyCode key: hotkeyRecordFullScreenKeyCode, modifiers key: hotkeyRecordFullScreenModifiers)
#   5 = History            (keyCode key: hotkeyHistoryKeyCode, modifiers key: hotkeyHistoryModifiers)
#   6 = OCR & QR           (keyCode key: hotkeyOCRKeyCode,    modifiers key: hotkeyOCRModifiers)
#   7 = Quick Capture      (keyCode key: hotkeyQuickCaptureKeyCode, modifiers key: hotkeyQuickCaptureModifiers)
#   8 = Scroll Capture     (keyCode key: hotkeyScrollCaptureKeyCode, modifiers key: hotkeyScrollCaptureModifiers)
#   9 = Open from Clipboard (keyCode key: hotkeyOpenClipboardKeyCode, modifiers key: hotkeyOpenClipboardModifiers)
#  10 = Capture Last Area  (keyCode key: hotkeyCaptureLastAreaKeyCode, modifiers key: hotkeyCaptureLastAreaModifiers)
#  11 = Pin from Clipboard (keyCode key: hotkeyPinClipboardKeyCode, modifiers key: hotkeyPinClipboardModifiers)
#  12 = Clear History      (keyCode key: hotkeyClearHistoryKeyCode, modifiers key: hotkeyClearHistoryModifiers)
#
# Disable any slot with: hotkeyDisabled_<slot> -int 1
# Common keyCodes: A=0, S=1, D=2, F=3, H=4, X=7, R=15, T=17
# Modifier bitmask: cmd=256, shift=512, option=1024, control=2048 (combine with +)
#
# Hotkeys — Capture Area → ⌘⇧S (keyCode 1 = S, modifiers 768 = cmd|shift)
defaults_write_if_absent "$APP" hotkeyKeyCode -int 1
defaults_write_if_absent "$APP" hotkeyModifiers -int 768
# Disable Quick Capture (default was ⌘⇧S)
defaults_write_if_absent "$APP" hotkeyDisabled_7 -int 1
# Disable Capture Screen (default was ⌘⇧F)
defaults_write_if_absent "$APP" hotkeyDisabled_2 -int 1

# Appearance
defaults_write_if_absent "$APP" hideMenuBarIcon -int 1

# Launch
defaults_write_if_absent "$APP" launchAtLogin -int 1

# Updates
defaults_write_if_absent "$APP" SUAutomaticallyUpdate -int 1

success "Macshot defaults set"
unset APP

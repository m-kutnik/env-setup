#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting Cap defaults"
APP_ID="so.cap.desktop"
STORE_FILE="$HOME/Library/Application Support/$APP_ID/store"

update_json "$STORE_FILE" ".general_settings.hideDockIcon" "true"
update_json "$STORE_FILE" ".general_settings.theme" '"dark"'
# update_json "$STORE_FILE" '.hotkeys.hotkeys.screenshotArea.code' '"KeyS"'
# update_json "$STORE_FILE" '.hotkeys.hotkeys.screenshotArea.meta' "true"
# update_json "$STORE_FILE" '.hotkeys.hotkeys.screenshotArea.shift' "true"
# update_json "$STORE_FILE" '.hotkeys.hotkeys.screenshotArea.ctrl' "false"
# update_json "$STORE_FILE" '.hotkeys.hotkeys.screenshotArea.alt' "false"

success "Cap defaults set"
unset APP_ID STORE_FILE

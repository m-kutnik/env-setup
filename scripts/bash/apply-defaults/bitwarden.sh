#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting Bitwarden defaults"

# Bitwarden is an Electron app that stores settings in its own data.json,
# not in macOS defaults. We use update_json (jq) to patch the config.

DATA_FILE="$HOME/Library/Containers/com.bitwarden.desktop/Data/Library/Application Support/Bitwarden/data.json"

if [ ! -f "$DATA_FILE" ]; then
  warn "Bitwarden data.json not found — is Bitwarden installed?"
  exit 0
fi

# Security
update_json "$DATA_FILE" '."global_desktopSettings_preventScreenshots"' 'true'
update_json "$DATA_FILE" '."global_desktopSettings_sshAgentEnabled"' 'true'

# Appearance
update_json "$DATA_FILE" '."global_theming_selection"' '"dark"'
update_json "$DATA_FILE" '."global_domainSettings_showFavicons"' 'true'

# Vault
update_json "$DATA_FILE" '."global.vaultTimeout"' '-1'
update_json "$DATA_FILE" '."global.vaultTimeoutAction"' '"lock"'

# Launch
update_json "$DATA_FILE" '."global_desktopSettings_openAtLogin"' 'false'

success "Bitwarden defaults set"

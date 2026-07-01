#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

if ! dscl . -read "/Groups/$BREW_GROUP" GroupMembership 2>/dev/null | grep -qw "$(whoami)"; then
  log "Adding $(whoami) to $BREW_GROUP group..."
  run sudo dseditgroup -o edit -a "$(whoami)" -t user "$BREW_GROUP"
  success "Done."
else
  skipped "$(whoami) is already in the $BREW_GROUP group."
fi

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"
require_linux

"$SCRIPT_DIR/../shared/uninstall-mise.sh" "$@"

success "Uninstall complete."

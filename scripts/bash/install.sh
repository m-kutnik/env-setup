#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

"$SCRIPT_DIR/xcode-install.sh" "$@"
"$SCRIPT_DIR/homebrew-setup.sh" "$@"
"$SCRIPT_DIR/homebrew-install-base.sh" "$@"
"$SCRIPT_DIR/repo-deps.sh" "$@"

success "Setup complete"

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

if ! xcode-select -p &>/dev/null; then
  log "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Follow the GUI prompt to complete installation, then re-run this script."
  exit 0
else
  skipped "Xcode Command Line Tools already installed."
fi

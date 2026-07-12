#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_utils/helpers.sh"

SRC="$REPO_ROOT/launchd/fda-launcher/main.c"

OUT="$BIN_DIR/fda-launcher"
HASH_FILE="$OUT.srchash"

log "Building fda-launcher..."

if [ ! -f "$SRC" ]; then
  warn "Source not found: $SRC"
  exit 1
fi

# Ensure env-setup bin directory exists
if [ ! -d "$BIN_DIR" ]; then
  log-secondary "Creating bin directory..."
  run sudo mkdir -p "$BIN_DIR"
  run sudo chown root:wheel "$BIN_DIR"
  run sudo chmod 755 "$BIN_DIR"
fi

NEW_HASH="$(shasum -a 256 "$SRC" | awk '{print $1}')"

# Skip rebuilding if main.c hasn't changed. This matters because rebuilding
# produces a new ad-hoc code signature, which invalidates any Full Disk
# Access grant already given to the old binary in System Settings.
if [ -x "$OUT" ] && sudo test -f "$HASH_FILE" && [ "$(sudo cat "$HASH_FILE")" = "$NEW_HASH" ]; then
  log-secondary "fda-launcher is up to date, skipping rebuild"
  success "fda-launcher build skipped (no changes)"
  exit 0
fi

if [ -x "$OUT" ]; then
  warn "Source changed, rebuilding fda-launcher"
  warn "This invalidates the existing Full Disk Access grant for it;"
  warn "you will need to re-add it in System Settings after this."
fi

TMP_BIN="$(mktemp)"
trap 'rm -f "$TMP_BIN"' EXIT
run clang -O2 -o "$TMP_BIN" "$SRC"
run codesign --force --sign - "$TMP_BIN"

run sudo mv "$TMP_BIN" "$OUT"
run sudo chown root:wheel "$OUT"
run sudo chmod 755 "$OUT"
echo "$NEW_HASH" | sudo tee "$HASH_FILE" >/dev/null
log-secondary "Installed $OUT"

success "fda-launcher built"

echo ""
warn "You need to grant fda-launcher Full Disk Access:"
log-secondary "System Settings -> Privacy & Security -> Full Disk Access -> +"
log-secondary "PATH: $OUT"
echo ""

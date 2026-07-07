UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$UTILS_DIR/../../.." && pwd)"

BREW_USER="brew"
BREW_GROUP="brew"
BREW_HOME="/var/brew"

BREW_SUDOERS_FILE="/private/etc/sudoers.d/brew_group"
BREW_PATHS_FILE="/etc/paths.d/homebrew"
BREW_SUDOERS_SRC="$UTILS_DIR/brew_group_sudoers"
BREW_BASHRC_SRC="$UTILS_DIR/brew_bashrc"
BREW_BASHRC_DST="$BREW_HOME/.bashrc"

WHITE='\033[1;97m'
GREY='\033[90m'
DARK_GREY='\033[38;5;236m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

run() {
  echo -e "  ${GREY}$*${RESET}"
  local exit_code=0
  local grey_esc reset_esc
  grey_esc=$(printf '\033[38;5;236m')
  reset_esc=$(printf '\033[0m')
  "$@" 2> >(sed "s,.*,$grey_esc&$reset_esc,") || exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo -e "${RED}Command failed (exit $exit_code)${RESET}"
    exit 1
  fi
}

log() {
  echo -e "${WHITE}$1${RESET}"
}

log-secondary() {
  echo -e "  ${GREY}$1${RESET}"
}

success() {
  echo -e "\n${GREEN}✓  $1${RESET}\n"
}

skipped() {
  echo -e "${DARK_GREY}⏭  $1${RESET}"
}

warn() {
  echo -e "${YELLOW}⚠  $1${RESET}"
}

error() {
  echo -e "${RED}✗  $1${RESET}"
}

FORCE=0
NO_BITWARDEN=0
BW_OWN_SESSION=0
BW_SESSION="${BW_SESSION:-}"

# Parse flags from CLI args
for arg in "$@"; do
  case "$arg" in
  --force | -f) FORCE=1 ;;
  --no-bitwarden) NO_BITWARDEN=1 ;;
  esac
done

# Also pick up flags from mise usage env vars
[[ "${usage_force:-}" == "true" ]] && FORCE=1
[[ "${usage_no_bitwarden:-}" == "true" ]] && NO_BITWARDEN=1

confirm() {
  if [ "$FORCE" -eq 1 ]; then
    return 0
  fi
  local prompt="$1"
  read -rp "$prompt [Y/n]: " choice
  case ${choice:-y} in
  [yY]*) return 0 ;;
  *) return 1 ;;
  esac
}

# Update a value in a JSON file using jq.
# Usage: update_json <file> <jq_key> <jq_value>
# Example: update_json "$STORE" ".general_settings.theme" '"dark"'
update_json() {
  local file="$1" key="$2" value="$3"

  if ! command -v jq &>/dev/null; then
    error "jq is required but not found"
    exit 1
  fi

  if [ ! -f "$file" ]; then
    warn "JSON file not found: $file"
    return 1
  fi

  local current
  current=$(jq -r "$key" "$file" 2>/dev/null)

  if [ "$FORCE" -eq 1 ]; then
    local tmp
    tmp=$(jq "$key = $value" "$file")
    echo "$tmp" >"$file"
    log-secondary "Forced $key = $value"
  elif [ "$current" = "null" ] || [ -z "$current" ]; then
    local tmp
    tmp=$(jq "$key = $value" "$file")
    echo "$tmp" >"$file"
    log-secondary "Set $key = $value"
  elif [ "$current" != "$(echo "$value" | tr -d '\"')" ]; then
    warn "$key is different (current: $current, desired: $(echo "$value" | tr -d '\"'))"
  fi
}

defaults_write_if_absent() {
  local domain="$1" key="$2" type="$3"
  shift 3
  local desired="$*"

  if [ "$FORCE" -eq 1 ]; then
    run defaults write "$domain" "$key" "$type" $desired
    return
  fi

  local current=$(defaults read "$domain" "$key" 2>/dev/null | tr -d '() \n\t')
  local compare=$(echo "$desired" | tr -d '() \n\t')
  if [ -n "$current" ] && [ "$current" != "$compare" ]; then
    warn "$key is different (current: $current, desired: $desired)"
  elif [ -z "$current" ]; then
    run defaults write "$domain" "$key" "$type" $desired
  fi
}

# Like defaults_write_if_absent but fetches the value from Bitwarden.
# Last argument is the Bitwarden item name; its password field is used as the value.
# Skipped entirely when --no-bitwarden is passed.
# Usage: defaults_write_if_absent_authenticated <domain> <key> <type> <bw-item-name>
defaults_write_if_absent_authenticated() {
  local domain="$1" key="$2" type="$3" bw_item="$4"

  if [ "$NO_BITWARDEN" -eq 1 ]; then
    return
  fi

  local value
  value=$(bw_get_password "$bw_item" || true)
  if [ -z "${value:-}" ]; then
    warn "Could not retrieve $key from Bitwarden"
    return
  fi

  if [ "$FORCE" -eq 1 ]; then
    log-secondary "Forcing $key write from Bitwarden"
    defaults write "$domain" "$key" "$type" "$value"
    return
  fi

  local current=$(defaults read "$domain" "$key" 2>/dev/null | tr -d '() \n\t')
  local compare=$(echo "$value" | tr -d '() \n\t')
  if [ -n "$current" ] && [ "$current" != "$compare" ]; then
    warn "Authenticated key:$key is different, skipping..."
  elif [ -z "$current" ]; then
    log-secondary "Writing $key from Bitwarden"
    defaults write "$domain" "$key" "$type" "$value"
  fi
}

# Unlock Bitwarden vault and store session key in BW_SESSION.
# Skipped when --no-bitwarden is passed.
# Usage: bw_unlock
bw_unlock() {
  if [ "$NO_BITWARDEN" -eq 1 ]; then
    skipped "Bitwarden skipped (--no-bitwarden)"
    return
  fi

  if ! command -v bw &>/dev/null; then
    error "Bitwarden CLI not found"
    exit 1
  fi

  if [ -n "${BW_SESSION:-}" ]; then
    return
  fi

  log-secondary "Unlocking Bitwarden vault…" >&2
  BW_SESSION=$(bw unlock --raw)
  export BW_SESSION
  BW_OWN_SESSION=1

  if [ -z "${BW_SESSION:-}" ]; then
    error "Bitwarden unlock failed"
    exit 1
  fi
}

# Lock Bitwarden vault and clear session key.
# Usage: bw_lock
bw_lock() {
  if [ "$BW_OWN_SESSION" -eq 1 ] && [ -n "${BW_SESSION:-}" ]; then
    bw lock --session "$BW_SESSION" --quiet 2>/dev/null || true
    unset BW_SESSION
    BW_OWN_SESSION=0
  fi
}

# Retrieve a Bitwarden item's password field.
# Requires bw_unlock to have been called first.
# Prints the password to stdout; returns 1 on any failure.
# Usage: bw_get_password <item-name>
bw_get_password() {
  local item="$1"

  if [ -z "${BW_SESSION:-}" ]; then
    bw_unlock
  fi

  if [ -z "${BW_SESSION:-}" ]; then
    exit 1
  fi

  local password
  password=$(bw get password "$item" --session "$BW_SESSION" 2>/dev/null || true)

  if [ -z "$password" ]; then
    warn "Could not retrieve password for '$item'"
    return 1
  fi

  echo "$password"
}

# Only trap for cleanup if we're running standalone (BW_SESSION not inherited)
if [ -z "${BW_SESSION:-}" ]; then
  trap bw_lock EXIT
fi

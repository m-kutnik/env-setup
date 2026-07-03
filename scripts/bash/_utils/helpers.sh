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
  echo -e "${GREY}$*${RESET}"
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

success() {
  echo -e "\n${GREEN}✓  $1${RESET}\n"
}

skipped() {
  echo -e "${DARK_GREY}⏭  $1${RESET}"
}

warn() {
  echo -e "${YELLOW}⚠  $1${RESET}"
}

FORCE=0
if [[ "${1:-}" == "--force" || "${1:-}" == "-f" ]]; then
  FORCE=1
fi

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

# Download resident SSH key from YubiKey to ~/.ssh/ (original filename), then add to agent.
# Usage: yubikey-import-ssh
yubikey-import-ssh() {
  local tmpdir keyname_file priv_key
  tmpdir=$(mktemp -d) || return 1
  keyname_file=$(mktemp) || {
    rm -rf "$tmpdir"
    return 1
  }

  (
    set -e
    cd "$tmpdir"
    ssh-keygen -K
    mkdir -p "$HOME/.ssh"
    local files=(*(N))
    local p=${${files:#*.pub}[1]}
    if [[ -z "$p" ]]; then
      echo "No resident key found"
      exit 1
    fi
    cp -n "$p" "$HOME/.ssh/"
    [[ -f "${p}.pub" ]] && cp -n "${p}.pub" "$HOME/.ssh/"
    echo -n "$p" >"$keyname_file"
  )
  local subshell_ret=$?
  priv_key=$(cat "$keyname_file" 2>/dev/null)
  rm -rf "$tmpdir" "$keyname_file"
  [[ $subshell_ret -ne 0 ]] && return $subshell_ret

  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/$priv_key"
}

[[ -n "${WSL_DISTRO_NAME:-}" ]] || return 0

WINDOWS_USERNAME="$(/mnt/c/WINDOWS/system32/cmd.exe /c echo %USERNAME% 2>/dev/null | tr -d '\r\n')"
[[ -n "$WINDOWS_USERNAME" ]] || return 0

if [[ ! -d "$HOME/.ssh" ]]; then
  mkdir -m 700 "$HOME/.ssh"
fi

export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
  rm -f "$SSH_AUTH_SOCK"
  (
    setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork \
      EXEC:"/mnt/c/Users/$WINDOWS_USERNAME/AppData/Local/Microsoft/WinGet/Packages/albertony.npiperelay_Microsoft.Winget.Source_8wekyb3d8bbwe/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &
  ) >/dev/null 2>&1
fi

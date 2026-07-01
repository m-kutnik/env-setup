if [[ "$(uname -s)" = Darwin ]]; then
  # Homebrew ssh-agent on fixed socket (must be started from shell so SK/hardware keys work;
  # LaunchAgent-started agents don't get FIDO2/HID access and refuse SK signing)
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  export SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.dylib
  export SSH_ASKPASS=/opt/homebrew/bin/ssh-askpass
  export DISPLAY=":0"
  /opt/homebrew/bin/ssh-add -l &>/dev/null
  if [ $? -eq 2 ]; then
    rm -f "$HOME/.ssh/agent.sock"
    eval "$(/opt/homebrew/bin/ssh-agent -s -a "$HOME/.ssh/agent.sock")"
  fi

  if ! /opt/homebrew/bin/ssh-add -l &>/dev/null; then
    for f in ~/.ssh/*; do
      [[ -f "$f" && "$f" != *.pub ]] && /opt/homebrew/bin/ssh-add "$f" 2>/dev/null
    done
  fi

  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

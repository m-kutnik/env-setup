if [[ "$(uname)" == Darwin ]]; then
  export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/bin/env-setup:/opt/homebrew/bin:$PATH"
  export LANG=en_US.UTF-8
else
  export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/bin/env-setup:$PATH"
  export LANG=C.UTF-8
fi

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

if command -v zed >/dev/null 2>&1; then
  export EDITOR="zed --wait"
elif command -v cursor >/dev/null 2>&1; then
  export EDITOR="cursor --wait"
else
  export EDITOR="nano"
fi

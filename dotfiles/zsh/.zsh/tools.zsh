eval "$(mise activate zsh)"
eval "$(mise hook-env -s zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
z4h source ~/.zsh/wsl-agent-bridge.sh

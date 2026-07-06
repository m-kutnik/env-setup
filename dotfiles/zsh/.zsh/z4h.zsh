zstyle ':z4h:' auto-update 'ask'
zstyle ':z4h:' auto-update-days '28'
zstyle ':z4h:bindkey' keyboard 'mac'

# zstyle ':z4h:' start-tmux command tmux -u new -A -D -t z4h
zstyle ':z4h:' start-tmux no

zstyle ':z4h:' prompt-at-bottom 'no'
zstyle ':z4h:' term-shell-integration 'yes'

# Disable z4h autosuggestions in favor of zsh-sage
zstyle ':z4h:zsh-autosuggestions' channel 'none'
# zstyle ':z4h:fzf' channel 'dev'
# zstyle ':z4h:powerlevel10k' channel 'dev'
# zstyle ':z4h:systemd' channel 'dev'
# zstyle ':z4h:zsh-completions' channel 'dev'
# zstyle ':z4h:zsh-syntax-highlighting' channel 'dev'
# zstyle ':z4h:zsh-history-substring-search' channel 'dev'
# zstyle ':z4h:terminfo' channel 'dev'
# zstyle ':z4h:tmux' channel 'dev'

zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
zstyle ':z4h:fzf-complete' fzf-bindings tab:repeat

zstyle ':z4h:direnv' enable 'no'
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
# zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
# zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*' enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
# zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

zstyle ':z4h:term-title:ssh' preexec '%n@'${${${Z4H_SSH##*:}//\%/%%}:-%m}': ${1//\%/%%}'
zstyle ':z4h:term-title:ssh' precmd '%n@'${${${Z4H_SSH##*:}//\%/%%}:-%m}': %~'
zstyle ':z4h:term-title:local' preexec '${1//\%/%%}'
zstyle ':z4h:term-title:local' precmd '%~'

# Create ~/.ssh/s/ directory for control sockets.
mkdir -p -m 0700 ~/.ssh/s

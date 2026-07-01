# zmodload zsh/zprof
# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Init z4h, must be done first.
z4h source ~/.zsh/z4h.zsh
z4h source ~/.zsh/fzf.zsh

z4h install z-shell/zsh-eza || return
z4h install m-kutnik/zsh-sage || return
# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

z4h source ~/.zsh/aliases.zsh
z4h source ~/.zsh/exports.zsh
z4h source ~/.zsh/keybindings.zsh
z4h source ~/.zsh/tools.zsh

z4h load z-shell/zsh-eza
z4h load m-kutnik/zsh-sage

for f in ~/.zsh/functions/*.zsh(N); do
  z4h source "$f"
done

# Lazy-load completions from ~/.zsh/completions/
for f in ~/.zsh/completions/_*(N); do
  local cmd=${${f:t}#_}
  if [[ -v commands[$cmd] ]]; then
    eval "function _${cmd}_lazy() {
      unfunction _${cmd}_lazy
      builtin source ${(q)f}
      _${cmd} \"\$@\"
    }"
    compdef _${cmd}_lazy $cmd
  fi
done

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot

# zprof

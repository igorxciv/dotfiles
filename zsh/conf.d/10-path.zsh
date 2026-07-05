# 10-path.zsh - PATH and Homebrew. Runs before completion/plugins, which need
# these binaries on PATH.

# typeset -U keeps path/fpath entries unique - no duplicate accumulation across
# re-sourced configs. `path` is tied to $PATH, `fpath` to the function search.
typeset -U path fpath

# Prepend a dir to PATH only if it exists (avoids stat'ing missing dirs later).
_prepend_path() { [[ -d "$1" ]] && path=("$1" $path) }

_prepend_path "$HOME/.local/bin"
_prepend_path "$HOME/bin"

# Rust / cargo - rustup writes this; it puts ~/.cargo/bin on PATH. (Was in the
# old ~/.zshenv.) typeset -U above keeps the entry from piling up on re-source.
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Homebrew (Apple Silicon /opt, Intel /usr/local). `brew shellenv` sets PATH,
# MANPATH, INFOPATH and HOMEBREW_PREFIX - which 50-completion and 90-plugins use.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x "$_brew" ]]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew

unset -f _prepend_path

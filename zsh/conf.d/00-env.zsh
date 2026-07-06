# 00-env.zsh - environment variables. First so everything below can read them.

# XDG base dirs - anchor other tools' config/cache/state off these instead of
# scattering dotfiles across $HOME. Set with defaults if the OS didn't.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Editor / pager. EDITOR is the universal fallback; VISUAL is for full-screen
# editors. Keep them in sync unless you deliberately want a lighter EDITOR.
export EDITOR="${EDITOR:-nvim}"
export VISUAL="$EDITOR"
export PAGER="${PAGER:-less}"

# Force a UTF-8 locale so tools don't fall back to C and mangle glyphs.
export LANG="${LANG:-en_US.UTF-8}"

# less: -R keep ANSI colors, -F quit if it fits one screen, -X don't wipe screen.
export LESS="-RFX"

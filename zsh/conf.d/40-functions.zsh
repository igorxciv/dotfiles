# 40-functions.zsh - small shell functions. Anything longer than a screen
# probably belongs in its own script on PATH ($HOME/.local/bin) instead.

# mkcd - make a directory (with parents) and step into it.
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# up - climb N directories: `up 3` == cd ../../..  (defaults to 1).
up() {
  local count="${1:-1}" target=""
  repeat "$count" target+="../"
  cd -- "${target:-.}"
}

# y - launch yazi and cd to wherever you left off (yazi's official wrapper).
# Without this, quitting yazi drops you back in the original directory.
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  # `command cat` sidesteps the cat -> bat alias from 30-aliases.zsh.
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# extract - unpack most archive types by extension, so you don't memorize flags.
extract() {
  if [[ ! -f "$1" ]]; then
    print -u2 "extract: '$1' is not a file"
    return 1
  fi
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz|*.txz)   tar xJf "$1" ;;
    *.tar)            tar xf  "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip  "$1" ;;
    *.zip)            unzip   "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.7z)             7z x    "$1" ;;
    *) print -u2 "extract: don't know how to unpack '$1'"; return 1 ;;
  esac
}

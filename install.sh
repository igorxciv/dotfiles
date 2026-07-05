#!/usr/bin/env bash
# install.sh - symlink dotfiles into place and seed the gitignored local files.
# Idempotent: safe to re-run. An existing real (non-symlink) target is moved to
# <target>.bak rather than destroyed.
set -euo pipefail

# Repo root = this script's directory, regardless of where it's invoked from.
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

info() { printf '\033[32m  ok\033[0m   %s\n' "$*"; }
act()  { printf '\033[36m%6s\033[0m %s\n' "$1" "$2"; }
warn() { printf '\033[33m%6s\033[0m %s\n' "$1" "$2"; }

# link SRC DEST - point DEST at SRC, backing up any existing real file/dir.
link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" ]]; then
    [[ "$(readlink "$dest")" == "$src" ]] && { info "$dest"; return; }
    rm "$dest"                                   # stale symlink -> replace
  elif [[ -e "$dest" ]]; then
    warn backup "$dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -s "$src" "$dest"
  act link "$dest -> $src"
}

# seed EXAMPLE TARGET - copy the template only when TARGET doesn't exist yet.
seed() {
  local example="$1" target="$2"
  if [[ -e "$target" ]]; then
    info "$target"
  else
    mkdir -p "$(dirname "$target")"
    cp "$example" "$target"
    act seed "$target (from ${example##*/})"
  fi
}

# --- symlinks ---
link "$REPO/zsh/.zshrc" "$HOME/.zshrc"
link "$REPO/kitty"      "$CONFIG/kitty"

# --- gitignored locals, seeded from *.example templates ---
seed "$REPO/zsh/conf.local.d/local.zsh.example" "$REPO/zsh/conf.local.d/local.zsh"
seed "$REPO/kitty/local.conf.example"           "$REPO/kitty/local.conf"

printf '\n\033[32mdone.\033[0m  restart your shell or: exec zsh\n'

#!/usr/bin/env bash
# bootstrap.sh - provision a fresh macOS machine end to end:
#   1. Xcode Command Line Tools (git + a C compiler for treesitter)
#   2. Homebrew
#   3. every package in ./Brewfile
#   4. ./install.sh (symlinks + seeds local overrides)
# Idempotent: safe to re-run. For packages only, use `brew bundle` directly.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
step() { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$*"; }

# 1. Xcode CLT - provides git and clang. `xcode-select -p` exits non-zero if absent.
if ! xcode-select -p >/dev/null 2>&1; then
  step "Installing Xcode Command Line Tools (accept the GUI prompt, then re-run)"
  xcode-select --install || true
  exit 0
fi

# 2. Homebrew - install if `brew` isn't already resolvable.
if ! command -v brew >/dev/null 2>&1; then
  step "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Put brew on PATH for the rest of THIS script (Apple Silicon /opt, Intel /usr/local).
for _b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x "$_b" ]] && eval "$("$_b" shellenv)" && break
done

# 3. Packages.
step "Installing packages from Brewfile"
brew bundle --file="$REPO/Brewfile"

# 4. Symlinks + local override seeding.
step "Linking dotfiles"
"$REPO/install.sh"

step "Done. Start a new shell:  exec zsh"

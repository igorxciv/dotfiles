# 90-plugins.zsh - plugins, loaded last. Deliberately manager-free: just source
# well-known plugins if they're installed (e.g. `brew install zsh-autosuggestions
# zsh-syntax-highlighting`). To adopt a real manager later, replace this file.
#
# Order matters: autosuggestions first, syntax-highlighting LAST (it wraps the
# final set of ZLE widgets, so anything added afterwards won't be highlighted).

_load_plugin() { [[ -r "$1" ]] && source "$1"; }

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  _load_plugin "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  _load_plugin "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

unset -f _load_plugin

# Tool shell-integrations that hook ZLE / chpwd. Run after compinit (50-*) so
# their completions register. zoxide gives `z <frecent dir>` and `zi` (fuzzy).
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# 50-completion.zsh - the completion system. Runs after 10-path so Homebrew's
# HOMEBREW_PREFIX and any tool completions are already on fpath's radar.

# Homebrew ships completion functions here; they must be on fpath BEFORE compinit.
[[ -n "$HOMEBREW_PREFIX" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

autoload -Uz compinit

# Cache the compdump under XDG cache and only rebuild it ~once a day: the glob
# qualifier (#qN.mh-24) matches iff the file exists and was modified <24h ago, so
# a fresh dump takes the -C fast path (skips the slow insecure-directory scan).
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
[[ -d "${_zcompdump:h}" ]] || mkdir -p "${_zcompdump:h}"
if [[ -n ${_zcompdump}(#qN.mh-24) ]]; then
  compinit -C -d "$_zcompdump"
else
  compinit -d "$_zcompdump"
fi
unset _zcompdump

# --- styling ---
zstyle ':completion:*' menu select                          # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # color matches like ls
zstyle ':completion:*' group-name ''                        # group by category
zstyle ':completion:*:descriptions' format '%B%d%b'         # bold group headers

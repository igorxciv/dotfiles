# 30-aliases.zsh - aliases. Prefer modern replacements when installed, but always
# leave a working portable (GNU + BSD/macOS) fallback.

# ls: eza if present, else plain ls with per-platform color flag.
if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first'
  alias ll='eza -lh  --group-directories-first --git'          # long, human sizes
  alias la='eza -lah --group-directories-first --git'          # + dotfiles
  alias tree='eza --tree'
  alias lt='eza --tree --level=2 --group-directories-first'    # shallow tree
elif ls --color=auto >/dev/null 2>&1; then   # GNU coreutils
  alias ls='ls --color=auto'
  alias ll='ls -lah'
else                                          # BSD ls (macOS)
  alias ls='ls -G'
  alias ll='ls -lah'
fi

alias grep='grep --color=auto'
(( $+commands[bat] )) && alias cat='bat --paging=never --style=plain'

# Safety nets - prompt before clobbering or deleting.
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Navigation.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git - the handful used dozens of times a day.
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

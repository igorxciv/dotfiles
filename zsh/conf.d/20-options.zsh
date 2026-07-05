# 20-options.zsh - shell behavior: history + setopt.

# --- history ---
# Store under XDG state (survives, but isn't "config"). Create the dir once.
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=50000        # events held in memory this session
SAVEHIST=50000        # events written to $HISTFILE

setopt EXTENDED_HISTORY       # record timestamp + duration per command
setopt SHARE_HISTORY          # live-share history across running shells
setopt HIST_IGNORE_ALL_DUPS   # drop older duplicates of a re-run command
setopt HIST_IGNORE_SPACE      # a leading space keeps a command out of history
setopt HIST_REDUCE_BLANKS     # tidy surplus whitespace before saving
setopt HIST_VERIFY            # expand !! etc. onto the line instead of running

# --- directories ---
setopt AUTO_CD                # `foo/` alone cd's into it
setopt AUTO_PUSHD             # every cd pushes onto the dir stack (`cd -<TAB>`)
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# --- globbing / interaction ---
setopt EXTENDED_GLOB          # ^ ~ # qualifiers in globs
setopt NO_CASE_GLOB           # case-insensitive filename globbing
setopt INTERACTIVE_COMMENTS   # allow # comments at the interactive prompt
setopt NO_BEEP
unsetopt FLOW_CONTROL         # free up ctrl-s / ctrl-q for other uses

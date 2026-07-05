# dotfiles

Personal macOS dotfiles for **zsh**, **kitty**, and **Neovim** (LazyVim).

Everything is driven by a single idempotent `install.sh` that symlinks each
config into place and seeds gitignored, machine-specific override files from
tracked `*.example` templates. Re-running is always safe.

## Layout

```
.
├── install.sh          # symlink everything + seed local overrides (idempotent)
├── zsh/
│   ├── .zshrc          # thin loader → conf.d/ then conf.local.d/
│   ├── .p10k.zsh       # Powerlevel10k prompt config (p10k configure edits this)
│   ├── conf.d/         # tracked, portable, loaded in numeric order
│   │   ├── 00-env.zsh        # XDG dirs, EDITOR, locale, LESS
│   │   ├── 10-path.zsh       # PATH, Homebrew, cargo
│   │   ├── 20-options.zsh    # history + setopt
│   │   ├── 30-aliases.zsh    # eza/bat/git/lazygit aliases
│   │   ├── 40-functions.zsh  # mkcd, up, extract, yazi `y` wrapper
│   │   ├── 50-completion.zsh # compinit (cached) + styling
│   │   ├── 60-prompt.zsh     # Powerlevel10k (standalone, no framework)
│   │   └── 90-plugins.zsh    # autosuggestions, syntax-highlighting, zoxide
│   └── conf.local.d/   # gitignored: machine-specific settings + secrets
├── kitty/              # → ~/.config/kitty
│   ├── kitty.conf      # loader; real config in conf.d/, os/, current-theme.conf
│   ├── conf.d/         # ordered modules (fonts, appearance, behavior, keymaps…)
│   ├── os/             # per-OS splits, selected via ${KITTY_OS}
│   └── local.conf      # gitignored per-machine overrides (seeded from example)
└── nvim/               # → ~/.config/nvim  (LazyVim starter)
    ├── init.lua, lua/config/*, lua/plugins/*
    ├── lazy-lock.json  # tracked → reproducible plugin versions
    └── lua/plugins/local.lua  # gitignored: secrets / per-machine plugin specs
```

## Install

```sh
git clone git@github.com:igorxciv/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
./install.sh
exec zsh          # pick up the new shell config
```

`install.sh` creates these symlinks (backing up any existing real file to
`*.bak` first):

| Link | Target |
|------|--------|
| `~/.zshrc` | `zsh/.zshrc` |
| `~/.p10k.zsh` | `zsh/.p10k.zsh` |
| `~/.config/kitty` | `kitty/` |
| `~/.config/nvim` | `nvim/` |

…and seeds these gitignored local files from their `*.example` templates (only
if missing):

- `zsh/conf.local.d/local.zsh`
- `kitty/local.conf`
- `nvim/lua/plugins/local.lua`

## Machine-specific config & secrets

Nothing secret or per-machine is committed. Each tool has a gitignored local
hook, seeded from a tracked `*.example` you can crib from:

- **zsh** — drop `*.zsh` files in `zsh/conf.local.d/`. They're sourced **last**,
  so they override everything in `conf.d/`. Good for extra `PATH` entries, work
  env, or `source ~/.secrets.zsh`.
- **kitty** — `kitty/local.conf` is `include`d last (font size, per-machine
  tweaks).
- **nvim** — `nvim/lua/plugins/local.lua` is auto-imported by LazyVim
  (`{ import = "plugins" }`); return plugin specs, keep API keys out of git.

## Requirements

- **Homebrew** — drives `brew shellenv` in `zsh/conf.d/10-path.zsh`.
- **kitty**, **Neovim** (0.9+ for LazyVim).
- Optional CLI tools the zsh config lights up when present (each is guarded, so
  nothing breaks if a tool is missing):

  ```sh
  brew install powerlevel10k eza bat zoxide yazi lazygit \
    zsh-autosuggestions zsh-syntax-highlighting
  ```

- **rustup** if you use Rust — `10-path.zsh` sources `~/.cargo/env` when it
  exists.

## Notes

- **No zsh framework.** Oh My Zsh was dropped in favor of a plain, ordered
  `conf.d/` and standalone Powerlevel10k — faster startup, no magic.
- **Reload:** `exec zsh` for shell changes; kitty auto-reloads its config on
  save; Neovim picks up plugin changes on next launch.

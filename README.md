# dotfiles

Personal macOS dotfiles for **zsh**, **kitty**, and **Neovim** (LazyVim).

Everything is driven by a single idempotent `install.sh` that symlinks each
config into place and seeds gitignored, machine-specific override files from
tracked `*.example` templates. Re-running is always safe.

## Layout

```
.
├── bootstrap.sh        # fresh machine: Xcode CLT + Homebrew + Brewfile + install.sh
├── Brewfile            # declarative package manifest (brew bundle)
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

**Fresh machine, one shot.** `bootstrap.sh` installs Xcode CLT + Homebrew,
every package in the `Brewfile`, then runs `install.sh`:

```sh
git clone https://github.com/igorxciv/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
./bootstrap.sh
exec zsh
```

If git isn't available yet (bare macOS), bootstrap triggers the Xcode Command
Line Tools install first — accept the GUI prompt, then re-run `./bootstrap.sh`.

**Already have Homebrew / just want the packages or symlinks:**

```sh
brew bundle --file=Brewfile   # install/update all dependencies
./install.sh                  # symlinks only (idempotent)
exec zsh
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

Everything below is captured in the [`Brewfile`](./Brewfile) — `bootstrap.sh`
(or `brew bundle`) installs it all. Listed here for reference:

**Hard requirements** (config targets these directly):

- **Homebrew** — drives `brew shellenv` in `zsh/conf.d/10-path.zsh`.
- **git** — repo clone + the `g*` aliases.
- **kitty**, **Neovim** (0.11.2+, LuaJIT, per LazyVim).
- **Agave Nerd Font Mono** — hardcoded in `kitty/conf.d/00-fonts.conf`; its
  powerline glyphs are what `tab_bar.py` draws with (`cask font-agave-nerd-font`).

**Prompt + zsh plugins** (sourced by path; the intended experience):

- **powerlevel10k**, **zsh-autosuggestions**, **zsh-syntax-highlighting**.

**CLI tools the zsh config lights up when present** (each guarded, so nothing
breaks if missing):

- **eza**, **bat**, **zoxide**, **yazi**, **lazygit**, **mise**.

**LazyVim requirements** ([official list](https://www.lazyvim.org/#-requirements)) —
**tree-sitter** (CLI) + a C compiler (Xcode CLT, which `bootstrap.sh` installs)
for treesitter, **fzf**, **ripgrep**, **fd** for fzf-lua. `curl` (blink.cmp) and
`git` ≥ 2.19 ship with macOS / are listed above.

**Optional:** **rustup** if you use Rust — `10-path.zsh` sources `~/.cargo/env`
when it exists (uncomment it in the `Brewfile`).

## Notes

- **No zsh framework.** Oh My Zsh was dropped in favor of a plain, ordered
  `conf.d/` and standalone Powerlevel10k — faster startup, no magic.
- **Reload:** `exec zsh` for shell changes; kitty auto-reloads its config on
  save; Neovim picks up plugin changes on next launch.

# Brewfile - declarative package manifest. Install everything with:
#   brew bundle --file=Brewfile
# Re-running is idempotent; `brew bundle cleanup` shows anything not listed here.

# --- terminal + editor (config targets) ---
cask "kitty"          # terminal; config symlinked to ~/.config/kitty
brew "neovim"         # LazyVim needs >= 0.9

# --- font (hardcoded in kitty/conf.d/00-fonts.conf + tab_bar.py glyphs) ---
cask "font-agave-nerd-font"

# --- prompt + zsh plugins (sourced by conf.d/60-prompt, 90-plugins) ---
brew "powerlevel10k"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# --- CLI tools the zsh config lights up when present (all guarded) ---
brew "eza"            # ls replacement (30-aliases)
brew "bat"            # cat replacement (30-aliases)
brew "zoxide"         # smart cd `z` (90-plugins)
brew "yazi"           # file manager, `y` wrapper (40-functions)
brew "lazygit"        # `lg` alias + nvim integration
brew "mise"           # runtime version manager (90-plugins)

# --- LazyVim requirements (https://www.lazyvim.org/#-requirements) ---
# neovim (>=0.11.2, LuaJIT), git (>=2.19), a Nerd Font, lazygit, and a C
# compiler (Xcode CLT) are already covered above. These complete the set:
brew "tree-sitter"    # tree-sitter-cli, needed by nvim-treesitter
brew "fzf"            # fuzzy finder for fzf-lua (>=0.25.1)
brew "ripgrep"        # fzf-lua live grep
brew "fd"             # fzf-lua find files
brew "git"            # aliases + repo clone (>=2.19 for partial clones)
# curl (blink.cmp completion engine) ships with macOS — no formula needed.

# --- optional: uncomment if you use Rust (10-path sources ~/.cargo/env) ---
# brew "rustup"

# .zshrc - loader only. Real config lives in conf.d/ (tracked, ordered) and
# conf.local.d/ (gitignored: machine-specific settings + secret sourcing).
#
# install.sh symlinks this to ~/.zshrc. Resolve the symlink back to the repo so
# the conf dirs are found no matter where the link lives (%x = this file, :A =
# absolutise + follow symlinks, :h = its directory).
ZSH_CONFIG_DIR="${${(%):-%x}:A:h}"

# Portable modules, loaded in filename order (00 -> 90). Numeric prefixes make
# ordering explicit: later files may rely on earlier ones (PATH before plugins).
# (N) is nullglob, so an empty or missing dir is silently skipped.
for _conf in "$ZSH_CONFIG_DIR"/conf.d/*.zsh(N); do
  source "$_conf"
done

# Machine-specific overrides + secrets, gitignored. Sourced LAST so they win.
for _conf in "$ZSH_CONFIG_DIR"/conf.local.d/*.zsh(N); do
  source "$_conf"
done
unset _conf

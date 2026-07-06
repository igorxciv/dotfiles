return {
  -- Catppuccin colorscheme (macchiato flavour).
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "macchiato",
      custom_highlights = function(colors)
        return {
          -- Subtle max-line-length guide that blends with macchiato.
          ColorColumn = { bg = colors.surface0 },
        }
      end,
    },
  },

  -- Load LazyVim with catppuccin.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

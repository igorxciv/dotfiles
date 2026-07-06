return {
  -- Hide the clock LazyVim puts in the far-right statusline section.
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- LazyVim defaults lualine_z to `os.date("%R")`; clear it to drop the time.
      opts.sections.lualine_z = {}
    end,
  },
}

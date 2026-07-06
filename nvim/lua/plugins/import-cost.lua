return {
  -- Show the bundle size of imported packages inline (JS/TS/Svelte).
  {
    "barrettruth/import-cost.nvim",
    lazy = true,
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
    init = function()
      -- Configured via a global; deps install automatically on first use.
      vim.g.import_cost = {
        package_manager = "npm",
      }
    end,
  },
}

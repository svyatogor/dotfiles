return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000, -- needs to be loaded in first
  config = function()
    require("tiny-inline-diagnostic").setup({
      -- Use icons defined in the diagnostic configuration
      use_icons_from_diagnostic = true,

      -- Set the arrow icon to the same color as the first diagnostic severity
      set_arrow_to_diag_color = true,
    })
    vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
  end,
}

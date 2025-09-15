return {
  "folke/snacks.nvim",
  opts = {
    picker = { ui_select = true },
  },
  keys = {
    {
      "<leader>gB",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git Branches",
    },
    -- {
    --   "<leader>ss",
    --   function()
    --     Snacks.picker.lsp_symbols()
    --   end,
    --   desc = "LSP Symbols",
    -- },
    -- {
    --   "<leader>sS",
    --   function()
    --     Snacks.picker.lsp_workspace_symbols()
    --   end,
    --   desc = "LSP Workspace Symbols",
    -- },
  },
}

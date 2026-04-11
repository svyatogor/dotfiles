return {
  "folke/snacks.nvim",
  opts = {
    picker = { ui_select = true },
    scratch = {
      ft = "markdown",
      win = {
        position = "right",
        height = 0,
        wo = {
          wrap = true,
          spell = false,
        },
      },
    },
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

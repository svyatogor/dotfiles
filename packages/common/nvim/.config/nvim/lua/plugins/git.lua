return {
  { "tpope/vim-fugitive" },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
    },
    opts = {
      kind = "vsplit",
      graph_style = "kitty",
      process_spinner = true,
      commit_editor = { kind = "vsplit" },
      commit_select_view = { kind = "vsplit" },
    },
  },
  -- {
  --   "sindrets/diffview.nvim",
  --   keys = {
  --     { "<leader>gD", "<cmd>DiffviewOpen<CR>", desc = "Open Diff View" },
  --   },
  -- },
}

return {
  { "tpope/vim-fugitive" },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
  },
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
  },
  -- {
  --   "sindrets/diffview.nvim",
  --   keys = {
  --     { "<leader>gD", "<cmd>DiffviewOpen<CR>", desc = "Open Diff View" },
  --   },
  -- },
}

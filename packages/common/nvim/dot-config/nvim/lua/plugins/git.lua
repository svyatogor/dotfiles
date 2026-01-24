return {
  { "tpope/vim-fugitive" },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<CR>", desc = "Open Diff View" },
    },
  },
}

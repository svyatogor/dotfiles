return {
  { "tpope/vim-fugitive" },
  {
    "dlyongemallo/diffview.nvim",
    version = "v0.32",
    cmd = "DiffviewOpen",
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<CR>", desc = "Open Diff View" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        cycle_layouts = {
          default = { "diff2_horizontal", "diff1_inline" },
        },
        inline = { style = "overleaf" },
        default = { layout = "diff1_inline" },
        merge_tool = { layout = "diff3_horizontal" },
      },
    },
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "dlyongemallo/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
    opts = {
      integrations = { diffview = true },
    },
  },
  -- Disable lazygit bindings from snacks
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gg", false },
      { "<leader>gG", false },
    },
  },
}

vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/NeogitOrg/neogit',
  { src = 'https://github.com/dlyongemallo/diffview.nvim', version = 'v0.37' },
}

require('diffview').setup {
  enhanced_diff_hl = true,
  view = {
    cycle_layouts = {
      default = { 'diff2_horizontal', 'diff1_inline' },
    },
    inline = { style = 'overleaf' },
    default = { layout = 'diff1_inline' },
    merge_tool = { layout = 'diff3_horizontal' },
  },
}

local neogit = require('neogit')
neogit.setup {
  graph_style = 'kitty',
  integrations = { diffview = true, snacks = true },
}

vim.keymap.set("n", "<leader>gg", neogit.open, { desc = "Open Neogit UI" })


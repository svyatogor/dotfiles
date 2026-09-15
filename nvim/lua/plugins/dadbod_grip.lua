vim.pack.add {
  'https://github.com/tpope/vim-dadbod',
  { src = 'https://github.com/joryeugene/dadbod-grip.nvim', version = vim.version.range '*' },
}

require('dadbod-grip').setup {
  completion = false,
  picker = 'snacks',
}

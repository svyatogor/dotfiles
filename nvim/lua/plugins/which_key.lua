vim.pack.add { 'https://github.com/folke/which-key.nvim' }

require('which-key').setup {
  preset = 'helix',
  delay = 300,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>a', group = 'AI/Claude Code' },
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]est' },
    { '<leader>u', group = '[U]I' },
    { '<leader>x', group = 'Diagnostics' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
    { 'gr', group = 'LSP Actions', mode = 'n' },
  },
}

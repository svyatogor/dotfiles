vim.pack.add { 'https://github.com/j-hui/fidget.nvim' }

require('fidget').setup {
  notification = {
    override_vim_notify = true,
    view = {
      stack_upwards = true,
      reflow = false,
    },
    window = {
      border = 'none',
      winblend = 100,
      align = 'bottom',
      h_align = 'right',
    },
  },
}

vim.keymap.set('n', '<leader>n', ':Fidget history<CR>', { desc = 'Notification History' })
vim.keymap.set('n', '<leader>un', ':Fidget clear<CR>', { desc = 'Dismiss All Notifications' })

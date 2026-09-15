vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/folke/todo-comments.nvim',
}

require('todo-comments').setup {
  signs = true,
  keywords = {
    REVIEW = { icon = '󰈈 ', color = 'default' },
  },
}

vim.keymap.set({ 'n', 'x' }, '<leader>ra', ':ReviewAdd<CR>', { desc = 'Add review comment' })
vim.keymap.set('n', '<leader>rl', '<cmd>TodoQuickFix keywords=REVIEW<cr>', { desc = 'List review comments' })
vim.keymap.set('n', '<leader>rs', '<cmd>TodoFzfLua keywords=REVIEW<cr>', { desc = 'Search review comments' })
vim.keymap.set('n', ']r', function() require('todo-comments').jump_next { keywords = { 'REVIEW' } } end, { desc = 'Next review comment' })
vim.keymap.set('n', '[r', function() require('todo-comments').jump_prev { keywords = { 'REVIEW' } } end, { desc = 'Previous review comment' })
vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next Todo Comment' })
vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Prev Todo Comment' })

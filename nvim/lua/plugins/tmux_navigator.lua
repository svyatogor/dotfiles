if vim.env.TMUX and vim.env.TMUX ~= '' then
  vim.pack.add { 'https://github.com/christoomey/vim-tmux-navigator' }
  return
end

if vim.env.TERM_PROGRAM ~= 'ghostty' then return end

vim.pack.add {
  'https://github.com/smart-splits-nvim/smart-splits.nvim',
  'https://github.com/smart-splits-nvim/backend-ghostty',
}

require('smart-splits').setup {}
require('ghostty-smart-splits').setup()

local splits = require 'smart-splits'

vim.keymap.set('n', '<C-h>', splits.move_cursor_left)
vim.keymap.set('n', '<C-j>', splits.move_cursor_down)
vim.keymap.set('n', '<C-k>', splits.move_cursor_up)
vim.keymap.set('n', '<C-l>', splits.move_cursor_right)

vim.keymap.set('n', '<M-h>', splits.resize_left)
vim.keymap.set('n', '<M-j>', splits.resize_down)
vim.keymap.set('n', '<M-k>', splits.resize_up)
vim.keymap.set('n', '<M-l>', splits.resize_right)

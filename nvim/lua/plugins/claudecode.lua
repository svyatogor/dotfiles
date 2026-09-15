vim.pack.add {
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/coder/claudecode.nvim',
  'https://github.com/pittcat/claude-fzf.nvim',
}

require('claudecode').setup {
  terminal = {
    provider = 'snacks',
  },
}
require('claude-fzf').setup {
  keymaps = {},
  logging = { console_logging = false },
}

local map = vim.keymap.set

map('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
map('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
map('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>', { desc = 'Resume Claude' })
map('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>', { desc = 'Continue Claude' })
map('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'Select Claude model' })
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add current buffer' })
map('x', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send to Claude' })
map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff' })
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff' })

map('n', '<leader>aF', '<cmd>ClaudeFzfFiles<cr>', { desc = 'Claude: add files' })
map('n', '<leader>ag', '<cmd>ClaudeFzfGrep<cr>', { desc = 'Claude: search and add' })
map('n', '<leader>aB', '<cmd>ClaudeFzfBuffers<cr>', { desc = 'Claude: add buffers' })
map('n', '<leader>aG', '<cmd>ClaudeFzfGitFiles<cr>', { desc = 'Claude: add git files' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'neo-tree', 'netrw', 'minifiles' },
  callback = function(event) map('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', { buffer = event.buf, desc = 'Add file to Claude' }) end,
})

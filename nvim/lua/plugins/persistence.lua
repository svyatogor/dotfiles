vim.pack.add { 'https://github.com/folke/persistence.nvim' }

local persistence
local function session()
  if not persistence then
    persistence = require 'persistence'
    persistence.setup {}
  end
  return persistence
end

vim.api.nvim_create_autocmd('BufReadPre', {
  group = vim.api.nvim_create_augroup('persistence', { clear = true }),
  once = true,
  callback = session,
})

vim.keymap.set('n', '<leader>qs', function() session().load() end, { desc = 'Restore Session' })
vim.keymap.set('n', '<leader>qS', function() session().select() end, { desc = 'Select Session' })
vim.keymap.set('n', '<leader>ql', function() session().load { last = true } end, { desc = 'Restore Last Session' })
vim.keymap.set('n', '<leader>qd', function() session().stop() end, { desc = "Don't Save Current Session" })

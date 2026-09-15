vim.pack.add {
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-neotest/neotest-jest',
  'https://github.com/olimorris/neotest-rspec',
}

require('neotest').setup {
  floating = { border = 'rounded' },
  status = { virtual_text = true },
  output = { open_on_run = true },
  adapters = {
    require 'neotest-rspec' {
      root_files = { 'Gemfile', 'gems.rb', '*.gemspec', '.rspec', '.git', '.gitignore', 'bin/rails' },
    },
    require 'neotest-jest' {
      cwd = function(path) return vim.fs.root(path, 'package.json') or vim.uv.cwd() end,
      env = { CI = 'true' },
    },
  },
}

local neotest = require 'neotest'

vim.keymap.set('n', '<leader>ta', neotest.run.attach, { desc = 'Attach to Test' })
vim.keymap.set('n', '<leader>tt', function() neotest.run.run(vim.fn.expand '%') end, { desc = 'Run File' })
vim.keymap.set('n', '<leader>tT', function() neotest.run.run(vim.uv.cwd()) end, { desc = 'Run All Test Files' })
vim.keymap.set('n', '<leader>tr', neotest.run.run, { desc = 'Run Nearest' })
vim.keymap.set('n', '<leader>tl', neotest.run.run_last, { desc = 'Run Last' })
vim.keymap.set('n', '<leader>ts', neotest.summary.toggle, { desc = 'Toggle Summary' })
vim.keymap.set('n', '<leader>to', function() neotest.output.open { enter = true, auto_close = true } end, { desc = 'Show Output' })
vim.keymap.set('n', '<leader>tO', neotest.output_panel.toggle, { desc = 'Toggle Output Panel' })
vim.keymap.set('n', '<leader>tS', neotest.run.stop, { desc = 'Stop' })
vim.keymap.set('n', '<leader>tw', function() neotest.watch.toggle(vim.fn.expand '%') end, { desc = 'Toggle Watch' })
vim.keymap.set('n', '<leader>td', function() neotest.run.run { strategy = 'dap' } end, { desc = 'Debug Nearest' })

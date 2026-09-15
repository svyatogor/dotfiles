vim.pack.add {
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/NvChad/nvim-colorizer.lua',
}
require('guess-indent').setup {}

if vim.g.have_nerd_font then
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
  MiniIcons.tweak_lsp_kind()
end

local ai = require 'mini.ai'
ai.setup {
  custom_textobjects = {
    g = require('mini.extra').gen_ai_spec.buffer(),
    t = false,
    k = ai.gen_spec.treesitter { a = { '@key' }, i = { '@key' } },
    v = ai.gen_spec.treesitter { a = { '@value' }, i = { '@value' } },
  },
  n_lines = 500,
}

require('mini.surround').setup()

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

require('colorizer').setup {
  filetypes = {
    'css',
    eruby = { mode = 'foreground' },
    html = { mode = 'foreground' },
    'lua',
    'javascript',
    'vue',
  },
}

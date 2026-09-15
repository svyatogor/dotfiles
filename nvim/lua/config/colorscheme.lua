vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }
require('catppuccin').setup {
  background = { dark = 'frappe' },
  transparent_background = true,
  float = { transparent = true },
  integrations = {
    mini = {
      enabled = true,
      indentscope_color = '',
    },
  },
}

vim.cmd.colorscheme 'catppuccin-nvim'

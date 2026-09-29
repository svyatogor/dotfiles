vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }
require('catppuccin').setup {
  background = { dark = 'frappe' },
  transparent_background = true,
  float = { transparent = true },
  lsp_styles = {
    underlines = {
      errors = { 'undercurl' },
      warnings = { 'undercurl' },
      information = { 'undercurl' },
      hints = { 'undercurl' },
      ok = { 'undercurl' },
    },
  },
  custom_highlights = function(colors)
    return {
      CursorLine = { bg = colors.mantle },
      CursorLineNr = { fg = colors.lavender, bold = true },
      Visual = { bg = colors.surface1 },
      WinSeparator = { fg = colors.surface0 },
      FloatBorder = { fg = colors.surface1 },
    }
  end,
  integrations = {
    mini = {
      enabled = true,
      indentscope_color = '',
    },
  },
}

vim.cmd.colorscheme 'catppuccin-nvim'

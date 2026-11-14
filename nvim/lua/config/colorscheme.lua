vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }
-- Accent colour (like in the VS Code port). Any catppuccin palette name:
-- rosewater flamingo pink mauve red maroon peach yellow green teal sky sapphire blue lavender
local accent = 'lavender'

-- terminal-colors (local/terminal-colors.nvim): schemes painted with the terminal's colours.
-- `catppuccin-terminal` is Catppuccin below with the terminal palette; `terminal-base16` maps
-- the same colours onto base16 roles. Stock `catppuccin-latte`/`-frappe`/… still work.
vim.opt.rtp:prepend(vim.fn.stdpath 'config' .. '/local/terminal-colors.nvim')
local scheme = 'catppuccin-terminal'

require('catppuccin').setup {
  background = { dark = 'frappe' },
  transparent_background = true,
  float = { transparent = true },
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { 'italic' }, -- Change the style of comments
    conditionals = { 'italic' },
    loops = {},
    functions = {},
    keywords = { 'italic' },
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    -- miscs = {}, -- Uncomment to turn off hard-coded styles
  },
  lsp_styles = {
    underlines = {
      errors = { 'undercurl' },
      warnings = { 'undercurl' },
      information = { 'undercurl' },
      hints = { 'undercurl' },
      ok = { 'undercurl' },
    },
  },
  -- custom_highlights = function(colors)
  --   return {
  --     CursorLine = { bg = colors.mantle },
  --     CursorLineNr = { fg = colors[accent], bold = true },
  --     Visual = { bg = colors.surface1 },
  --     WinSeparator = { fg = colors.surface0 },
  --     FloatBorder = { fg = colors[accent] },
  --   }
  -- end,
  -- Plugins are added after this file loads, so auto-detection misses them; enable explicitly.
  integrations = {
    blink_cmp = { enabled = true, style = 'bordered' },
    diffview = true,
    dap = true,
    dap_ui = true,
    fidget = true,
    fzf = true,
    gitsigns = { enabled = true, nvim_surround = false },
    lsp_trouble = true,
    mini = {
      enabled = true,
      indentscope_color = accent,
    },
    native_lsp = { enabled = true },
    neogit = true,
    neotest = true,
    neotree = true,
    render_markdown = true,
    snacks = { enabled = true },
    treesitter = true,
    which_key = true,
  },
}

require('terminal-colors').setup()
vim.cmd.colorscheme(scheme)

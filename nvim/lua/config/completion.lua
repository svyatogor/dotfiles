vim.pack.add { { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

vim.pack.add { { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
    list = { selection = { preselect = false } },
    ghost_text = { enabled = true },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'dadbod_grip' },
    providers = {
      dadbod_grip = { name = 'Grip SQL', module = 'dadbod-grip.completion.blink' },
    },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
  cmdline = {
    keymap = {
      preset = 'cmdline',
      ['<Right>'] = false,
      ['<Left>'] = false,
    },
    completion = {
      menu = { auto_show = function() return vim.fn.getcmdtype() == ':' end },
    },
  },
}

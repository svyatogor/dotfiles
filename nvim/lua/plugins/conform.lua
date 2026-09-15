vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

local conform = require 'conform'

conform.setup {
  notify_no_formatters = true,
  default_format_opts = {
    timeout_ms = 3000,
    lsp_format = 'fallback',
  },
  format_on_save = {},
  formatters_by_ft = {
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    ruby = { 'rubocop' },
    eruby = { 'erb_format' },
    go = { 'goimports', 'gofumpt' },
    sh = { 'shfmt' },
    nix = { 'nixfmt' },
  },
  formatters = {
    erb_format = {
      args = { '--stdin', '--print-width', '120' },
    },
    injected = {
      options = {
        ignore_errors = true,
        lang_to_formatters = {
          lua = { 'stylua' },
        },
      },
    },
  },
}

vim.keymap.set({ 'n', 'x' }, '<leader>cf', function() conform.format { async = true } end, { desc = 'Format' })
vim.keymap.set(
  { 'n', 'x' },
  '<leader>cF',
  function() conform.format { formatters = { 'injected' }, timeout_ms = 3000 } end,
  { desc = 'Format Injected Languages' }
)

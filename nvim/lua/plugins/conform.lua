vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

local conform = require 'conform'

conform.setup {
  notify_no_formatters = true,
  default_format_opts = {
    timeout_ms = 3000,
    lsp_format = 'fallback',
  },
  format_on_save = function(buf)
    if vim.g.autoformat == false or vim.b[buf].autoformat == false then return end
    return {}
  end,
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

-- LazyVim parity: <leader>uf global, <leader>uF buffer-local (vim.g/b.autoformat == false disables)
Snacks.toggle({
  name = 'Auto Format (Global)',
  get = function() return vim.g.autoformat ~= false end,
  set = function(enabled) vim.g.autoformat = enabled end,
}):map '<leader>uf'
Snacks.toggle({
  name = 'Auto Format (Buffer)',
  get = function() return vim.b.autoformat ~= false and vim.g.autoformat ~= false end,
  set = function(enabled) vim.b.autoformat = enabled end,
}):map '<leader>uF'

vim.keymap.set({ 'n', 'x' }, '<leader>cf', function() conform.format { async = true } end, { desc = 'Format' })
vim.keymap.set(
  { 'n', 'x' },
  '<leader>cF',
  function() conform.format { formatters = { 'injected' }, timeout_ms = 3000 } end,
  { desc = 'Format Injected Languages' }
)

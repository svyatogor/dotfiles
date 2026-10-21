local function augroup(name) return vim.api.nvim_create_augroup('kickstart_' .. name, { clear = true }) end

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup 'highlight_yank',
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'json_conceal',
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function() vim.opt_local.conceallevel = 1 end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'markdown_diagnostics',
  pattern = 'markdown',
  callback = function() vim.diagnostic.enable(false, { bufnr = 0 }) end,
})

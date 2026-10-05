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

-- A bg-only CursorLine on a diff line renders as an underline; keep just the line number there.
-- Diffview sets 'diff' with autocmds suppressed, so OptionSet misses it; its own event covers that.
vim.api.nvim_create_autocmd({ 'OptionSet', 'VimEnter', 'User' }, {
  group = augroup 'diff_cursorline',
  pattern = { 'diff', '*', 'DiffviewDiffBufWinEnter' },
  callback = function(ev)
    if ev.event == 'OptionSet' and ev.match ~= 'diff' then return end
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      vim.wo[win][0].cursorlineopt = vim.wo[win].diff and 'number' or 'both'
    end
  end,
})

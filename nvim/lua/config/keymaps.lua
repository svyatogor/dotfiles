vim.keymap.set('n', '<Esc>', function()
  local namespace = vim.api.nvim_get_namespaces()['nvim.multicursor']
  if namespace then
    local cursors = vim.api.nvim_buf_get_extmarks(0, namespace, 0, -1, { limit = 1 })
    if #cursors > 0 then vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1) end
  end
  vim.cmd.nohlsearch()
end, { desc = 'Clear Multicursors and Search Highlight' })

vim.keymap.set('n', '<C-n>', [[<Cmd>let @/ = '\<' . expand('<cword>') . '\>'<CR>lbQn<Cmd>nohlsearch<CR>]], { desc = 'Add Cursor at Next Word Occurrence' })
vim.keymap.set(
  'n',
  '<leader>ma',
  [[<Cmd>let @/ = '\<' . expand('<cword>') . '\>'<CR>lb1Q<Cmd>nohlsearch<CR>]],
  { desc = 'Add Cursors at All Word Occurrences' }
)

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = false,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
vim.keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
vim.keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })

vim.keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
vim.keymap.set('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close Other Tabs' })
vim.keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
vim.keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
vim.keymap.set('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

vim.keymap.set('v', '<leader>yf', function()
  local start_line = vim.fn.line 'v'
  local end_line = vim.fn.line '.'
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  local ref = path .. ':' .. start_line .. '-' .. end_line
  vim.fn.setreg('+', ref)
  vim.notify(ref, vim.log.levels.INFO)

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end, { desc = 'Copy file reference with line range' })

vim.keymap.set('n', '<leader>yf', function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  local ref = path .. ':' .. vim.fn.line '.'
  vim.fn.setreg('+', ref)
  vim.notify(ref, vim.log.levels.INFO)
end, { desc = 'Copy file reference with line' })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center', noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center', noremap = true, silent = true })

local function diagnostic_goto(count, severity)
  return function() vim.diagnostic.jump { count = count, severity = severity and vim.diagnostic.severity[severity] or nil } end
end
vim.keymap.set('n', ']e', diagnostic_goto(1, 'ERROR'), { desc = 'Next Error' })
vim.keymap.set('n', '[e', diagnostic_goto(-1, 'ERROR'), { desc = 'Prev Error' })
vim.keymap.set('n', ']w', diagnostic_goto(1, 'WARN'), { desc = 'Next Warning' })
vim.keymap.set('n', '[w', diagnostic_goto(-1, 'WARN'), { desc = 'Prev Warning' })

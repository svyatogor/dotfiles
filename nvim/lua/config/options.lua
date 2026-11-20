-- Core Neovim settings
vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- macOS "Russian – Phonetic" → ABC, dumped from the system layout via UCKeyTranslate
local ru = [[асдфчгзхцвбяшерытъьжоуюиплйкэнмщАСДФЧГЗХЦВБЯШЕРЫТЪЬЖОУЮИПЛЙКЭНМЩ]]
local en = [[asdfhgzxcvbqweryt=-]ou[ipljk\nm`ASDFHGZXCVBQWERYT+_}OU{IPLJK|NM~]]
vim.o.langmap = vim.fn.escape(ru, [[;,"|\]]) .. ';' .. vim.fn.escape(en, [[;,"|\]])

-- With a Cyrillic letter in 'langmap', Nvim never matches typed `<C-ш>` against
-- mappings, so langmapper's CTRL copies are dead. Swap the key before mapping instead.
-- TODO: drop this and re-enable langmapper's `map_all_ctrl` once
-- https://github.com/neovim/neovim/issues/42850 is fixed.
local ctrl_ru = {}
local en_chars = vim.fn.split(en, [[\zs]])
for i, char in ipairs(vim.fn.split(ru, [[\zs]])) do
  ctrl_ru[vim.keycode('<C-' .. char .. '>')] = vim.keycode('<C-' .. en_chars[i] .. '>')
end
vim.on_key(function(_, typed)
  local key = ctrl_ru[typed]
  if not key then return end
  vim.api.nvim_feedkeys(key, 'mit', false)
  return ''
end, vim.api.nvim_create_namespace 'ctrl_langmap')

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false

vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.fillchars = {
  eob = ' ',
  fold = ' ',
  foldopen = '',
  foldclose = '',
  foldsep = ' ',
  diff = '╱',
}
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.wildmode = 'longest:full,full'
vim.o.wildoptions = 'pum'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldmethod = 'expr'
vim.opt.foldlevelstart = 99

vim.o.winborder = 'rounded'
vim.opt.iskeyword:append '-'

-- gq wrap column; editorconfig's max_line_length overrides this per-project
vim.o.textwidth = 100

vim.opt.termguicolors = true
vim.g.clipboard = 'osc52'
vim.opt.clipboard = 'unnamedplus'

vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
}

-- Ensure basic parsers are installed
local parsers = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
}
require('nvim-treesitter').install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- Check if a parser exists and load it
  if not vim.treesitter.language.add(language) then return end
  -- Enable syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- Enable treesitter based folds
  -- For more info on folds see `:help folds`
  -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  -- vim.wo.foldmethod = 'expr'

  -- Check if treesitter indentation is available for this language, and if so enable it
  -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  -- Enable treesitter based indentation
  if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      -- Enable the parser if it is already installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})

require('nvim-treesitter-textobjects').setup { move = { set_jumps = true }, select = { lookahead = true } }

-- ]f/]c/]a jump to the start of the next function/class/parameter, ]F/]C/]A to its end; [ reverses.
local move = require 'nvim-treesitter-textobjects.move'
for key, query in pairs { f = '@function.outer', c = '@comment.outer', C = '@class.outer', a = '@parameter.inner' } do
  local name = query:match '@(%w+)'
  local function jump(fn, dir)
    vim.keymap.set(
      { 'n', 'x', 'o' },
      dir,
      function() move[fn](query, 'textobjects') end,
      { desc = dir:sub(1, 1) == ']' and 'Next ' .. name or 'Prev ' .. name }
    )
  end
  jump('goto_next_start', ']' .. key)
  jump('goto_previous_start', '[' .. key)
  jump('goto_next_end', ']' .. key:upper())
  jump('goto_previous_end', '[' .. key:upper())
end

-- af/if function, aa/ia parameter, ac/ic comment (works with d, y, v, etc.)
local select = require 'nvim-treesitter-textobjects.select'
for key, queries in pairs {
  f = { outer = '@function.outer', inner = '@function.inner' },
  a = { outer = '@parameter.outer', inner = '@parameter.inner' },
  c = { outer = '@comment.outer', inner = '@comment.inner' },
} do
  local name = queries.outer:match '@(%w+)'
  vim.keymap.set({ 'x', 'o' }, 'a' .. key, function() select.select_textobject(queries.outer, 'textobjects') end, { desc = 'Select around ' .. name })
  vim.keymap.set({ 'x', 'o' }, 'i' .. key, function() select.select_textobject(queries.inner, 'textobjects') end, { desc = 'Select inside ' .. name })
end

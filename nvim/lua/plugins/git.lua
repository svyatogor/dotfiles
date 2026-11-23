vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/NeogitOrg/neogit',
  { src = 'https://github.com/dlyongemallo/diffview.nvim' },
}

require('diffview').setup {
  enhanced_diff_hl = true,
  persist_selections = { enabled = true },
  view = {
    cycle_layouts = {
      default = { 'diff2_horizontal', 'diff1_inline' },
    },
    inline = { style = 'overleaf' },
    default = { layout = 'diff1_inline' },
    merge_tool = { layout = 'diff3_horizontal' },
  },
}

-- A new file has an empty old side, so every line would be painted as added. Skip the
-- inline render then and show the file as plain code.
local inline_diff = require 'diffview.scene.inline_diff'
local render = inline_diff.render
inline_diff.render = function(bufnr, old_lines, new_lines, opts)
  if #old_lines == 0 then return inline_diff.clear(bufnr) end
  return render(bufnr, old_lines, new_lines, opts)
end

local neogit = require('neogit')
neogit.setup {
  graph_style = 'kitty',
  integrations = { diffview = true, snacks = true },
}

vim.keymap.set("n", "<leader>gg", neogit.open, { desc = "Open Neogit UI" })

vim.keymap.set('n', '<leader>gw', '<cmd>Gwrite<cr>', { desc = 'Git Write (stage file)' })

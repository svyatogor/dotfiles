require('mini.files').setup {
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 80,
  },
}

local minifiles_toggle = function(...)
  if MiniFiles.close() == nil then MiniFiles.open(...) end
end

vim.keymap.set('n', '<leader>fm', minifiles_toggle, { desc = 'Mini Files' })

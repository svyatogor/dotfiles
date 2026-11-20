-- Duplicates every mapping for the Russian layout; must load before any keymap is set
vim.pack.add { 'https://github.com/Wansmer/langmapper.nvim' }

require('langmapper').setup {
  use_layouts = { 'ru' },
  -- Never fire with Cyrillic in 'langmap' (neovim/neovim#42850); CTRL keys are swapped in options.lua
  map_all_ctrl = false,
  custom_desc = function(desc) return desc or '' end,
  layouts = {
    ru = {
      id = 'com.apple.keylayout.Russian-Phonetic',
      -- Same key positions as the 'langmap' in options.lua
      default_layout = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ<>:"{}~abcdefghijklmnopqrstuvwxyz,.;'[]`=-\+_|]],
      layout = [[АБЦДЕФГЧИЙКЛМНОПЯРСТУВШХЫЗ<>:"ЮЖЩабцдефгчийклмнопярстувшхыз,.;'южщъьэЪЬЭ]],
    },
  },
}

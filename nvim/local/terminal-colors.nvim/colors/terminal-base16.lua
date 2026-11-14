local terminal = require 'terminal-colors'
local c = terminal.colors
if not c then error 'terminal-base16: the terminal reported no generated 256-colour palette' end
terminal.sync_background()

-- Slots as in terminal-colors' header: base00–07 are ramp steps from bg to fg (in light themes
-- too), base08–0F the accents, with orange (5,2,0) and brown (3,1,0) from the cube.
require('mini.base16').setup {
  palette = {
    base00 = c.bg, -- background
    base01 = c[232], -- status bars, cursor line
    base02 = c[236], -- selection
    base03 = c[244], -- comments
    base04 = c[249], -- dark foreground
    base05 = c.fg, -- foreground
    base06 = c[254],
    base07 = c[255],
    base08 = c[1], -- variables, tags, diff deleted
    base09 = c[208], -- numbers, constants
    base0A = c[3], -- types, search
    base0B = c[2], -- strings, diff inserted
    base0C = c[6], -- regex, escapes
    base0D = c[4], -- functions
    base0E = c[5], -- keywords
    base0F = c[130], -- deprecated, embedded
  },
}

-- base16 paints diffs as coloured text on base01, nearly bg, and diffview's inline view only
-- takes the background. Cube cells next to the bg corner are bg tinted toward a hue instead.
local hl = vim.api.nvim_set_hl
hl(0, 'DiffAdd', { bg = c[22] }) -- (0,1,0) toward green
hl(0, 'DiffDelete', { fg = c[1], bg = c[52] }) -- (1,0,0) toward red
hl(0, 'DiffChange', { bg = c[17] }) -- (0,0,1) toward blue
hl(0, 'DiffText', { bg = c[18] }) -- (0,0,2): the changed part of a changed line, one step more
-- Diffview's `enhanced_diff_hl` draws deletions with this group (Comment by default), so give
-- removed text the same red tint instead of a grey that reads as a comment.
hl(0, 'DiffviewDiffDeleteDim', { fg = c[244], bg = c[52] })

vim.g.colors_name = 'terminal-base16'

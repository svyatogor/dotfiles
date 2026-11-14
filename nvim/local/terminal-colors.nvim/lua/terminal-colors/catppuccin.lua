-- `catppuccin-terminal`: Catppuccin with the terminal's colours as a 27th flavour.
--
-- Not a real Catppuccin flavour: Catppuccin hard-codes "latte is the light one" (the compiled
-- theme even sets 'background' from it), so an extra flavour would always be dark. Instead the
-- terminal palette goes into the documented `color_overrides`, on top of whichever stock flavour
-- matches 'background'. Everything else — styles, integrations, custom highlights — is the
-- user's own `require('catppuccin').setup()`, which must run before the scheme loads.
local M = {}

-- Catppuccin's names onto terminal slots (layout in init.lua): accents are the ANSI colours,
-- in-between hues are cube cells (r,g,b), greys are ramp steps. Mantle and crust sit just past
-- base in Catppuccin; the ramp never leaves bg..fg, so its first steps stand in. Shell tools use
-- the same slots for the same roles: README, "Terminal colours".
---@param c TerminalColors
function M.palette(c)
  return {
    rosewater = c[224], -- (5,4,4)
    flamingo = c[211], -- (5,2,3)
    pink = c[13],
    mauve = c[5],
    red = c[1],
    maroon = c[9],
    peach = c[208], -- (5,2,0)
    yellow = c[3],
    green = c[2],
    teal = c[6],
    sky = c[14],
    sapphire = c[39], -- (0,3,5)
    blue = c[4],
    lavender = c[12],
    text = c.fg,
    subtext1 = c[252],
    subtext0 = c[249],
    overlay2 = c[246],
    overlay1 = c[244],
    overlay0 = c[241],
    surface2 = c[239],
    surface1 = c[236],
    surface0 = c[234],
    base = c.bg,
    mantle = c[232],
    crust = c[233],
  }
end

-- The user's options as they were before we added the overrides; stock flavours get them back.
local user_options

function M.load()
  local catppuccin = require 'catppuccin'

  if not user_options then
    user_options = vim.deepcopy(catppuccin.options)
    -- Loading a stock flavour after this one must not keep the terminal palette.
    vim.api.nvim_create_autocmd('ColorSchemePre', {
      group = vim.api.nvim_create_augroup('terminal-colors.catppuccin', {}),
      callback = function(ev)
        if vim.startswith(ev.match, 'catppuccin') and ev.match ~= 'catppuccin-terminal' then catppuccin.setup(vim.deepcopy(user_options)) end
      end,
    })
  end

  local options = vim.deepcopy(user_options)
  local colors = require('terminal-colors').colors
  if colors then
    -- Changed options make Catppuccin recompile, so switching to and from a stock flavour costs a
    -- recompile. A separate `compile_path` would avoid it, but Catppuccin's compiler captures
    -- the options table once and would keep writing to the old path.
    options.color_overrides = vim.tbl_deep_extend('force', options.color_overrides, { all = M.palette(colors) })
  end

  require('terminal-colors').sync_background()
  catppuccin.setup(options)
  catppuccin.load()
  vim.g.colors_name = 'catppuccin-terminal'
end

return M

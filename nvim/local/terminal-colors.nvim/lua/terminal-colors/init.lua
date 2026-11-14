-- terminal-colors: Neovim colour schemes painted with the terminal's own colours.
--
-- The terminal owns the colours: ask it for fg/bg (OSC 10/11) and its 256-colour palette
-- (OSC 4). The schemes in colors/ map those slots onto their own roles; this module only fetches
-- them and repaints the active scheme when the terminal's theme changes.
--
-- Only a palette the terminal generated from its theme is used (Ghostty `palette-generate` +
-- `palette-harmonious`, Rex "Use extended theme palette"): the 16–231 cube then spans bg,
-- ANSI 1–6 and fg at its corners (cell (r,g,b), 0–5 per axis, is slot 16 + 36r + 6g + b; so
-- 208 = (5,2,0) is the theme's orange), and 232–255 is a ramp from bg to fg. A stock xterm palette has nothing to do with the theme, so it counts as no palette.
local M = {}

---@class TerminalColors
---@field fg string
---@field bg string
---@field [integer] string Slots 0–255 as #rrggbb.

---@type TerminalColors?
M.colors = nil

-- Schemes painted from the terminal; a palette change reloads whichever of them is active.
local schemes = { 'catppuccin-terminal', 'terminal-base16' }

-- Every OSC query goes out at once, followed by a DSR. Terminals answer in order, so a DSR
-- after our first reply is ours and means everything has arrived. A DSR before it belongs to
-- someone else's query (Neovim sends its own) and is skipped.
local payload = (function()
  local parts = { '\027]10;?\027\\\027]11;?\027\\' }
  for i = 0, 255 do
    parts[#parts + 1] = ('\027]4;%d;?\027\\'):format(i)
  end
  parts[#parts + 1] = '\027[5n'
  return table.concat(parts)
end)()

local function channel(h) return math.floor(tonumber(h, 16) / (16 ^ #h - 1) * 255 + 0.5) end

-- Replies look like `rgb:rrrr/gggg/bbbb` (1–4 hex digits per channel), or `rgba:` with alpha.
local function hex(reply)
  local r, g, b = reply:match '^rgba?:(%x+)/(%x+)/(%x+)'
  if r then return ('#%02x%02x%02x'):format(channel(r), channel(g), channel(b)) end
end

local function generated(c)
  for i = 0, 255 do
    if not c[i] then return false end
  end
  return c[16] == c.bg and c[231] == c.fg
end

---@param on_done fun(colors: TerminalColors?)
---@param timeout? integer ms; vim.tty.request's default when nil
local function query(on_done, timeout)
  local seen = {}
  vim.tty.request(payload, { timeout = timeout, on_timeout = function() on_done(nil) end }, function(resp)
    if resp:match '^\027%[0n' then
      if not seen.fg then return end
      on_done(generated(seen) and seen or nil)
      return true
    end

    local osc, reply = resp:match '^\027%](%d+);(.*)'
    if osc == '10' then
      seen.fg = hex(reply)
    elseif osc == '11' then
      seen.bg = hex(reply)
    elseif osc == '4' then
      local i, colour = reply:match '^(%d+);(.*)'
      seen[tonumber(i)] = hex(colour)
    end
  end)
end

-- Same luminance test Neovim uses at startup.
local function background_of(c)
  local r, g, b = c.bg:match '#(%x%x)(%x%x)(%x%x)'
  local luminance = (0.299 * tonumber(r, 16) + 0.587 * tonumber(g, 16) + 0.114 * tonumber(b, 16)) / 255
  return luminance < 0.5 and 'dark' or 'light'
end

-- Schemes call this before painting: the terminal's bg decides light or dark, not the scheme
-- loaded before (a stock dark flavour leaves 'background' dark). Only on a switch from another
-- scheme, though. When one of ours is reloading, either Neovim has just set 'background' from
-- the terminal's light/dark report and the palette here is still the old one, about to be
-- refreshed, or the refresh below has set it already; correcting it would undo the switch.
function M.sync_background()
  if not M.colors or vim.list_contains(schemes, vim.g.colors_name) then return end
  local background = background_of(M.colors)
  if vim.o.background ~= background then
    -- Changing 'background' reloads g:colors_name; that's the previous scheme, mid-switch.
    vim.g.colors_name = nil
    vim.o.background = background
  end
end

-- Cues to fetch the palette again; unchanged colours don't repaint:
-- - OSC 11 reply: Neovim re-asks for the background when the terminal reports a light/dark
--   switch (mode 2031).
-- - FocusGained: mode 2031 says nothing about a switch between two dark themes, but those
--   happen in the terminal's settings, away from Neovim.
-- - UIEnter, only if startup got nothing: a second chance at an unanswered first query.
local function watch()
  local busy = false
  local function refresh()
    if busy then return end
    busy = true
    query(function(c)
      busy = false
      if not c or vim.deep_equal(c, M.colors) then return end
      M.colors = c
      local name = vim.g.colors_name
      if not vim.list_contains(schemes, name) then return end
      local background = background_of(c)
      if vim.o.background ~= background then
        vim.o.background = background -- reloads the scheme
      else
        vim.cmd.colorscheme(name)
      end
    end)
  end

  local group = vim.api.nvim_create_augroup('terminal-colors', {})
  vim.api.nvim_create_autocmd('FocusGained', { group = group, callback = refresh })
  vim.api.nvim_create_autocmd('UIEnter', {
    group = group,
    once = true,
    callback = function()
      if not M.colors then refresh() end
    end,
  })
  vim.api.nvim_create_autocmd('TermResponse', {
    group = group,
    callback = function(ev)
      if ev.data.sequence:match '^\027%]11;' then refresh() end
    end,
  })
end

-- Fetch the palette now, so a `:colorscheme` right after already has it, and keep following
-- the terminal. Blocks startup briefly (the terminal answers in a few ms) so the first frame
-- already has the right colours.
function M.setup()
  local has_tty = vim.iter(vim.api.nvim_list_uis()):any(function(ui) return ui.stdout_tty end)
  if has_tty then
    local done = false
    query(function(c)
      M.colors, done = c, true
    end, 200)
    vim.wait(200, function() return done end, 1)
  end
  watch()
end

return M

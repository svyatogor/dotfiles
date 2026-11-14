-- The terminal owns the colours: ask it for fg/bg (OSC 10/11) and the 16 ANSI slots (OSC 4),
-- then spread them into a full Catppuccin palette. Catppuccin keeps supplying the highlight
-- groups and plugin integrations; only the colours come from Ghostty.
local M = {}

local function channel(h) return math.floor(tonumber(h, 16) / (16 ^ #h - 1) * 255 + 0.5) end

-- Replies look like `rgb:rrrr/gggg/bbbb` (1–4 hex digits per channel), or `rgba:` with alpha.
local function rgb(reply)
  local r, g, b = reply:match '^rgba?:(%x+)/(%x+)/(%x+)'
  if r then return { channel(r), channel(g), channel(b) } end
end

local function mix(a, b, t)
  local function at(i) return math.floor(a[i] + (b[i] - a[i]) * t + 0.5) end
  return ('#%02x%02x%02x'):format(at(1), at(2), at(3))
end

-- Terminals have no orange or second blue, so those are blends of their neighbours. Greys are
-- a ramp from bg to fg, matching Catppuccin's own text → surface → base spacing.
local function palette(c)
  local black = { 0, 0, 0 }
  local function hex(key) return mix(c[key], c[key], 0) end
  local function ramp(t) return mix(c.bg, c.fg, t) end
  return {
    rosewater = mix(c.fg, c[9], 0.3),
    flamingo = mix(c[9], c[13], 0.5),
    pink = hex(13),
    mauve = hex(5),
    red = hex(1),
    maroon = hex(9),
    peach = mix(c[1], c[3], 0.5),
    yellow = hex(3),
    green = hex(2),
    teal = hex(6),
    sky = hex(14),
    sapphire = mix(c[4], c[6], 0.5),
    blue = hex(4),
    lavender = hex(12),
    text = hex 'fg',
    subtext1 = ramp(0.85),
    subtext0 = ramp(0.72),
    overlay2 = ramp(0.6),
    overlay1 = ramp(0.5),
    overlay0 = ramp(0.4),
    surface2 = ramp(0.3),
    surface1 = ramp(0.2),
    surface0 = ramp(0.12),
    base = hex 'bg',
    mantle = mix(c.bg, black, 0.12),
    crust = mix(c.bg, black, 0.22),
  }
end

-- Every OSC query goes out at once, followed by a DSR. Terminals answer in order, so a DSR
-- after our first reply is ours and means everything has arrived. A DSR before it belongs to
-- someone else's query (Neovim sends its own) and is skipped.
local function query(on_done)
  local seen = {}
  local payload = '\027]10;?\027\\\027]11;?\027\\'
  for i = 0, 15 do
    payload = payload .. ('\027]4;%d;?\027\\'):format(i)
  end

  vim.tty.request(payload .. '\027[5n', { on_timeout = function() on_done(nil) end }, function(resp)
    if resp:match '^\027%[0n' then
      if not seen.fg then return end
      local complete = seen.fg and seen.bg
      for i = 0, 15 do
        complete = complete and seen[i]
      end
      on_done(complete and palette(seen) or nil)
      return true
    end

    local osc, reply = resp:match '^\027%](%d+);(.*)'
    if osc == '10' then
      seen.fg = rgb(reply)
    elseif osc == '11' then
      seen.bg = rgb(reply)
    elseif osc == '4' then
      local i, colour = reply:match '^(%d+);(.*)'
      seen[tonumber(i)] = rgb(colour)
    end
  end)
end

-- Blocks startup briefly (the terminal answers in a few ms) so the first frame already has the
-- right colours. Nil when there's no terminal to ask, or it doesn't answer.
function M.get()
  local has_tty = vim.iter(vim.api.nvim_list_uis()):any(function(ui) return ui.stdout_tty end)
  if not has_tty then return end

  local result, done
  query(function(p)
    result, done = p, true
  end)
  vim.wait(200, function() return done end, 1)
  return result
end

-- Neovim already re-asks for the background when the terminal reports a light/dark switch
-- (mode 2031); that OSC 11 reply is our cue to fetch the whole palette. Mode 2031 says nothing
-- about a switch between two dark themes, but those happen in the terminal's settings, so
-- coming back to Neovim (FocusGained) is the other cue. Unchanged colours don't repaint.
function M.watch(current, on_change)
  local busy = false
  local function refresh()
    if busy then return end
    busy = true
    query(function(p)
      busy = false
      if p and not vim.deep_equal(p, current) then
        current = p
        on_change(p)
      end
    end)
  end

  local group = vim.api.nvim_create_augroup('config.terminal_palette', {})
  vim.api.nvim_create_autocmd('FocusGained', { group = group, callback = refresh })
  vim.api.nvim_create_autocmd('TermResponse', {
    group = group,
    callback = function(ev)
      if ev.data.sequence:match '^\027%]11;' then refresh() end
    end,
  })
end

return M

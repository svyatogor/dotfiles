-- Migrated from tmux, Ghostty, Herdr and Alacritty configs.

-- Physical keys ([KeyB] etc.) so bindings work in any keyboard layout.

-- tmux (prefix ctrl+b). Spelling the prefix as [KeyB] hides the app's built-in
-- ctrl+b sequences, so the ones in use are listed here.
rex.bind("ctrl+[KeyB]>ctrl+[KeyB]", "pane.send_key", { key = "ctrl+b" })
rex.bind("ctrl+[KeyB]>[Minus]", "pane.split", { direction = "down" })
rex.bind("ctrl+[KeyB]>shift+[Backslash]", "pane.split", { direction = "right" })
rex.bind("ctrl+[KeyB]>[KeyR]", "client.config.reload")
rex.bind("ctrl+[KeyB]>[KeyZ]", "pane.zoom")
rex.bind("ctrl+[KeyB]>[KeyX]", "pane.close")
rex.bind("ctrl+[KeyB]>[KeyC]", "client.tab.new")
rex.bind("ctrl+[KeyB]>[KeyN]", "client.tab.next")
rex.bind("ctrl+[KeyB]>[KeyP]", "client.tab.previous")

-- Ghostty

-- ctrl+hjkl moves between panes, except in Neovim, which gets the key and
-- hands focus back to Rex at its own edge (nvim/lua/plugins/tmux_navigator.lua).
local terminal = "com.superlogical.terminal"

local function in_nvim(ctx)
  local p = rex.block.call(terminal, "process", { block_id = ctx.block_id })
  return p ~= nil and p.foreground ~= nil and p.foreground.name == "nvim"
end

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+[Key" .. key:upper() .. "]", function(ctx)
    if in_nvim(ctx) then
      -- Write the control byte itself: forwarding the key would send ctrl+<cyrillic>
      -- under a Russian layout, which Neovim doesn't map.
      rex.block.call(terminal, "write", { block_id = ctx.block_id, data = string.char(key:byte() - 96) })
    else
      rex.session.focus_direction({ direction = direction })
    end
    return true
  end)
end

-- App
rex.bind("super+[KeyB]", "client.sidebar.toggle")
rex.bind("super+[KeyK]", "com.superlogical.terminal.clear")
rex.bind("super+shift+[KeyS]", "session.switch")

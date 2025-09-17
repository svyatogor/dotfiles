local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()
wezterm.add_to_config_reload_watch_list(os.getenv("HOME") .. "/.local/share/wezterm/colors")
local function hex_to_rgb(color)
	local hex = color:gsub("#", "")
	if #hex == 3 then
		hex = hex:sub(1, 1) .. hex:sub(1, 1) .. hex:sub(2, 2) .. hex:sub(2, 2) .. hex:sub(3, 3) .. hex:sub(3, 3)
	end
	local r = tonumber(hex:sub(1, 2), 16) or 0
	local g = tonumber(hex:sub(3, 4), 16) or 0
	local b = tonumber(hex:sub(5, 6), 16) or 0
	return r, g, b
end

local function rgb_to_hex(r, g, b)
	return string.format("#%02x%02x%02x", math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
end

local function blend(color_a, color_b, amount)
	local r1, g1, b1 = hex_to_rgb(color_a)
	local r2, g2, b2 = hex_to_rgb(color_b)
	local blend_amount = math.min(math.max(amount or 0, 0), 1)
	local r = r1 * (1 - blend_amount) + r2 * blend_amount
	local g = g1 * (1 - blend_amount) + g2 * blend_amount
	local b = b1 * (1 - blend_amount) + b2 * blend_amount
	return rgb_to_hex(r, g, b)
end

local function lighten(color, amount)
	return blend(color, "#ffffff", amount)
end

local function darken(color, amount)
	return blend(color, "#000000", amount)
end

local function luminance(color)
	local function to_linear(v)
		v = v / 255
		if v <= 0.03928 then
			return v / 12.92
		end
		return ((v + 0.055) / 1.055) ^ 2.4
	end
	local r, g, b = hex_to_rgb(color)
	r, g, b = to_linear(r), to_linear(g), to_linear(b)
	return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

local function extend_with_tab_bar(base)
	if base.tab_bar then
		return base
	end

	local background = base.background or "#1e1e1e"
	local foreground = base.foreground or "#d0d0d0"
	local accent = (base.ansi and (base.ansi[6] or base.ansi[5] or base.ansi[4])) or base.cursor_bg or foreground
	local is_light_background = luminance(background) > 0.5

	local function surface(amount)
		if is_light_background then
			return darken(background, amount)
		end
		return lighten(background, amount)
	end

	local function on_surface(amount)
		if is_light_background then
			return darken(foreground, amount)
		end
		return lighten(foreground, amount)
	end

	local active_bg
	if is_light_background then
		active_bg = darken(accent, 0.25)
	else
		active_bg = lighten(accent, 0.1)
	end

	base.tab_bar = {
		background = surface(0.1),
		active_tab = {
			bg_color = active_bg,
			fg_color = base.cursor_fg or base.selection_fg or foreground,
			intensity = "Normal",
			italic = false,
			strikethrough = false,
			underline = "None",
		},
		inactive_tab = {
			bg_color = surface(0.2),
			fg_color = on_surface(0.1),
			intensity = "Normal",
			italic = false,
			strikethrough = false,
			underline = "None",
		},
		inactive_tab_hover = {
			bg_color = surface(0.15),
			fg_color = foreground,
			intensity = "Normal",
			italic = false,
			strikethrough = false,
			underline = "None",
		},
		new_tab = {
			bg_color = surface(0.25),
			fg_color = on_surface(0.2),
			intensity = "Normal",
			italic = false,
			strikethrough = false,
			underline = "None",
		},
		new_tab_hover = {
			bg_color = surface(0.18),
			fg_color = base.selection_fg or foreground,
			intensity = "Normal",
			italic = false,
			strikethrough = false,
			underline = "None",
		},
		inactive_tab_edge = surface(0.22),
	}

	return base
end

do
	local config_dir = os.getenv("HOME") .. "/.local/share/wezterm"
	local theme_path = config_dir .. "/colors/tinted-theming.toml"
	local ok, scheme = pcall(wezterm.color.load_scheme, theme_path)
	if ok and scheme then
		local scheme_colors = extend_with_tab_bar(scheme.colors or scheme)
		config.colors = scheme_colors
		if config.colors and config.colors.cursor_border then
			config.colors.cursor_bg = config.colors.cursor_border
		end
	else
		wezterm.log_error("Failed to load scheme at " .. theme_path .. "; falling back to named scheme")
		config.color_scheme = "tinted-theming"
	end
end

local function tab_title(tab_info)
	if tab_info.tab_title and #tab_info.tab_title > 0 then
		return tab_info.tab_title
	end
	return tab_info.active_pane.title
end

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		icons_enabled = true,
		theme = config.colors,
		tabs_enabled = true,
		section_separators = {
			left = wezterm.nerdfonts.ple_upper_left_triangle,
			right = wezterm.nerdfonts.ple_lower_right_triangle,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.ple_upper_left_triangle,
			right = wezterm.nerdfonts.ple_lower_right_triangle,
		},
	},
	sections = {
		tabline_a = { {
			"mode",
			fmt = function(str)
				return str:sub(1, 1)
			end,
		} },
		tabline_b = {},
		tabline_c = { " " },
		tab_active = {
			"index",
			--   { 'parent', padding = 0 },
			--   '/',
			tab_title,
			" ",
			{
				"zoomed",
				padding = 0,
			},
		},
		tab_inactive = {
			"index", -- { 'process', padding = { left = 0, right = 0 } } ,
			-- '::',
			tab_title,
		},
		-- tabline_x = { 'ram', 'cpu' },
		tabline_x = { "" },
		-- tabline_y = { 'datetime', 'battery' },
		tabline_y = { "battery" },
		tabline_z = { "cpu" },
	},
	extensions = {},
})
tabline.apply_to_config(config)

config.font = wezterm.font_with_fallback({
	"Maple Mono",
	-- {
	-- 	family = "Symbols Nerd Font Mono",
	-- 	scale = 0.9,
	-- },
})
config.font_size = 13
config.line_height = 1.1

config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW|MACOS_FORCE_SQUARE_CORNERS"
config.window_background_opacity = 0.93
config.macos_window_background_blur = 60

config.use_cap_height_to_scale_fallback_fonts = true
config.bold_brightens_ansi_colors = false

config.window_padding = {
	left = 15,
	right = 15,
	top = 15,
	bottom = 15,
}
local search_mode = wezterm.gui.default_key_tables().search_mode

table.insert(
	search_mode,
	{ key = "c", mods = "CTRL", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) }
)
config.key_tables = {
	search_mode = search_mode,
}
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "f",
		mods = "CMD",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(act.Search("CurrentSelectionOrEmptyString"), pane)
			window:perform_action(
				act.Multiple({
					act.CopyMode("ClearPattern"),
					act.CopyMode("ClearSelectionMode"),
					act.CopyMode("MoveToScrollbackBottom"),
				}),
				pane
			)
		end),
	},
	{
		key = "k",
		mods = "CMD",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = act.SendKey({ key = "a", mods = "CTRL" }),
	},
	-- Toggle transparency in increments
	{
		key = "t",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local overrides = window:get_config_overrides() or {}
			local current_opacity = overrides.window_background_opacity or 0.9

			-- Cycle through opacity values from 0.8 to 1.0 in 0.05 increments
			local opacity_values = { 0.8, 0.85, 0.9, 0.95, 1.0 }

			-- Find current index and move to next
			local current_index = 1
			for i, value in ipairs(opacity_values) do
				if math.abs(value - current_opacity) < 0.01 then
					current_index = i
					break
				end
			end

			local next_index = (current_index % #opacity_values) + 1
			overrides.window_background_opacity = opacity_values[next_index]
			window:set_config_overrides(overrides)
		end),
	},
}
config.term = "xterm-256color"
config.underline_position = "200%"

-- turn off actual beeps so you only see the flash
config.audible_bell = "Disabled"

-- choose how the flash is drawn
config.visual_bell = {
	fade_in_duration_ms = 60,
	fade_out_duration_ms = 60,
	target = "BackgroundColor", -- or "ForegroundColor" or "CursorColor"
}

config.colors = config.colors or {}
config.colors.visual_bell = config.colors.visual_bell or "#bbe"

return config

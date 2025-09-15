local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

local color_scheme = "Catppuccin Frappe"

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
		theme = color_scheme,
		tabs_enabled = true,
		theme_overrides = {},
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
	-- "Lilex",
	"Ubuntu Mono",
	{
		family = "Symbols Nerd Font Mono",
		scale = 0.9,
	},
})
config.font_size = 14
config.line_height = 1.3
config.font_rules = {
	{
		intensity = "Half",
		italic = false,
		font = wezterm.font_with_fallback({
			{
				family = "Lilex",
				weight = "Light",
			},
		}),
	},
}

config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW|MACOS_FORCE_SQUARE_CORNERS"
config.window_background_opacity = 0.93
config.macos_window_background_blur = 60

config.color_scheme = color_scheme
config.use_cap_height_to_scale_fallback_fonts = true

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
			local current_opacity = overrides.window_background_opacity or 0.93

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

config.colors.visual_bell = "#bbe"

return config

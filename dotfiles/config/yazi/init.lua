-- Circadia light: recolour yatline-catppuccin's Latte theme, same map as flavors/circadia-light.yazi
local circadia = {
	["#dce0e8"] = "#e5dcc6", ["#e6e9ef"] = "#eee7d6", ["#ccd0da"] = "#e5dcc6", ["#4c4f69"] = "#28323a",
	["#6c6f85"] = "#46535f", ["#1e66f5"] = "#0048b3", ["#8839ef"] = "#7a1f7a", ["#d20f39"] = "#843900",
	["#40a02b"] = "#005f2f", ["#df8e1d"] = "#843900", ["#04a5e5"] = "#1c60a2", ["#7287fd"] = "#4b1fa3",
	["#209fb5"] = "#095b62", ["#dd7878"] = "#843900", ["#ea76cb"] = "#7a1f7a", ["#e64553"] = "#843900",
	["#fe640b"] = "#843900", ["#179299"] = "#095b62",
}
local function recolour(t)
	for k, v in pairs(t) do
		if type(v) == "table" then
			recolour(v)
		elseif circadia[v] then
			t[k] = circadia[v]
		end
	end
	return t
end
local catppuccin_theme = recolour(require("yatline-catppuccin"):setup("latte"))
require("smart-enter"):setup({
	open_multi = true,
})
require("yatline"):setup({
	theme = catppuccin_theme,
	show_background = false,

	header_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
			},
			section_b = {
				{ type = "string", custom = false, name = "date", params = { "%X" } },
			},
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_path" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})
require("git"):setup()

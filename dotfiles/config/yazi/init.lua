-- Terminal palette indices, not hex: the terminal owns the colours (README, "Terminal colours").
-- Names and slots are those of terminal-colors.nvim's catppuccin.lua.
local theme = {
	section_separator_open = "",
	section_separator_close = "",
	inverse_separator_open = "",
	inverse_separator_close = "",
	part_separator_open = "",
	part_separator_close = "",

	style_a = {
		fg = "232",
		bg_mode = { normal = "4", select = "5", un_set = "1" },
	},
	style_b = { bg = "234", fg = "reset" },
	style_c = { bg = "232", fg = "reset" },

	permissions_t_fg = "2",
	permissions_r_fg = "3",
	permissions_w_fg = "1",
	permissions_x_fg = "14",
	permissions_s_fg = "12",

	selected = { icon = "󰻭", fg = "3" },
	copied = { icon = "", fg = "2" },
	cut = { icon = "", fg = "1" },

	total = { icon = "", fg = "3" },
	succ = { icon = "", fg = "2" },
	fail = { icon = "", fg = "1" },
	found = { icon = "", fg = "4" },
	processed = { icon = "", fg = "2" },
}
require("smart-enter"):setup({
	open_multi = true,
})
require("yatline"):setup({
	theme = theme,
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
	-- Available values: "plain", "rounded"
	set = "rounded",
})
require("git"):setup()

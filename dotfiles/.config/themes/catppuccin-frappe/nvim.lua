return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			transparent_background = true,
			integrations = {
				diffview = true,
			},
			custom_highlights = function(colors)
				return {
					DiffDelete = { bg = colors.surface0, fg = colors.surface0 },
					DiffviewDiffAddAsDelete = { bg = colors.surface0 },
				}
			end,
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-frappe",
		},
	},
}

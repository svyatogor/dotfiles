-- Default to frappe; OSC11.nvim corrects via TermResponse immediately after startup
local colorscheme = "catppuccin-frappe"

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
      colorscheme = colorscheme,
    },
  },
}

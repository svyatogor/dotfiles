return {
  "afonsofrancof/OSC11.nvim",
  opts = {
    on_dark = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme("catppuccin-frappe")
    end,
    on_light = function()
      vim.opt.background = "light"
      vim.cmd.colorscheme("catppuccin-latte")
    end,
  },
  config = function(_, opts)
    require("osc11").setup(opts)
    -- Send initial OSC 11 query to trigger TermResponse on startup
    io.stdout:write("\027]11;?\027\\")
  end,
}

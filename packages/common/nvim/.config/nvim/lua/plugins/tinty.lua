return {
  { "RRethy/base16-nvim" },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = function()
        return require("config.tinty").apply()
      end
    end,
  },
}

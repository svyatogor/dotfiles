return {
  -- { "RRethy/base16-nvim" },
  {
    "tinted-theming/tinted-vim",
    -- config = function()
    --   local tinted = require("tinted-colorscheme")
    --   tinted.setup(nil, {
    --     supports = {
    --       live_reload = true,
    --     },
    --   })
    -- end,
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = function()
        return require("config.tinty").apply()
      end
    end,
  },
}

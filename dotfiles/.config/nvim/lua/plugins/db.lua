return {
  {
    "joryeugene/dadbod-grip.nvim",
    version = "*",
    dependencies = { "tpope/vim-dadbod" },
    opts = {
      completion = false, -- blink drives completion instead of the built-in omnifunc
      picker = "snacks",
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- provider's enabled() checks vim.b.db, so it stays quiet in non-DB buffers
        default = { "dadbod_grip" },
        providers = {
          dadbod_grip = { name = "Grip SQL", module = "dadbod-grip.completion.blink" },
          -- lang.sql extra's vim-dadbod-completion source; grip covers the same ground
          dadbod = {
            enabled = function()
              return false
            end,
          },
        },
      },
    },
  },
}

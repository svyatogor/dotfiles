return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline", -- moves command line to bottom
      },
      presets = { command_palette = false },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        matcher = { frecency = true, history_bonus = true },
        formatters = {
          file = {
            truncate = 80,
          },
        },
        layout = "ivy",
      },
      zen = {
        dim = false,
        git_signs = true,
        mini_diff_signs = true,
        zoom = {
          toggles = {},
          show = { statusline = true, tabline = true },
          win = {
            backdrop = { transparent = true, blend = 40 },
            width = 120,
          },
        },
      },
    },
  },
  "nvim-tree/nvim-web-devicons",
  {
    "NvChad/nvim-colorizer.lua", -- Highlight hex and rgb colors within Neovim
    -- TODO: autoenable
    cmd = "ColorizerToggle",
    opts = {
      filetypes = {
        "css",
        eruby = { mode = "foreground" },
        html = { mode = "foreground" },
        "lua",
        "javascript",
        "vue",
      },
    },
  },
}

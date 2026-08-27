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
  {
    "stevearc/quicker.nvim",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
    -- ponytail: <leader>x* instead of <leader>q/<leader>l, which are LazyVim's
    -- quit and Lazy prefixes; these two lhs override the Trouble defaults.
    keys = {
      {
        "<leader>xq",
        function()
          require("quicker").toggle()
        end,
        desc = "Toggle quickfix",
      },
      {
        "<leader>xl",
        function()
          require("quicker").toggle({ loclist = true })
        end,
        desc = "Toggle loclist",
      },
      { ">", "<cmd>lua require('quicker').expand()<CR>", ft = "qf", desc = "Expand quickfix content" },
      { "<", "<cmd>lua require('quicker').collapse()<CR>", ft = "qf", desc = "Collapse quickfix content" },
    },
  },
}

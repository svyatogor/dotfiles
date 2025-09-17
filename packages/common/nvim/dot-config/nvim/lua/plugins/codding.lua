return {
  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
    opts = {
      default_mappings = true,
      opacity = 10,
    },
  },
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    priority = 1000,
    opts = {},
  },
  {
    "echasnovski/mini.ai",
    opts = function(_, opts)
      local ai = require("mini.ai")
      opts.custom_textobjects.t = false
      opts.custom_textobjects.k = ai.gen_spec.treesitter({
        a = { "@key" },
        i = { "@key" },
      })

      opts.custom_textobjects.v = ai.gen_spec.treesitter({
        a = { "@value" },
        i = { "@value" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "K",
        function()
          require("pretty_hover").hover()
        end,
      }

      opts.diagnostics = {
        float = {
          border = "rounded", -- choose from "single", "double", "rounded", "shadow", "solid"
        },
      }
    end,
  },
}

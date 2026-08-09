return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          enabled = false,
        },
        tsgo = {
          enabled = true,
          -- Force UTF-16 to match ESLint's encoding. Without this, the position
          -- encoding mismatch causes LazyVim's `has = "codeAction"` check to fail,
          -- making <leader>ca silently not work.
          capabilities = {
            general = {
              positionEncodings = { "utf-16" },
            },
          },
        },
        eslint = {
          settings = {
            -- Run ESLint on change, not just save
            run = "onType",
            -- Experimental: may help with faster validation
            experimental = {
              useFlatConfig = nil, -- auto-detect
            },
          },
        },
      },
    },
  },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   opts = {
  --     settings = {
  --       separate_diagnostic_server = false,
  --       expose_as_code_action = "all",
  --       -- code_lens = "all",
  --     },
  --   },
  --   -- keys = {
  --   -- },
  -- },
}

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
        tsc = {
          enabled = true,
          settings = {
            ["js/ts"] = {
              inlayHints = {
                parameterNames = {
                  enabled = "literals",
                  suppressWhenArgumentMatchesName = true,
                },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = true },
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
              implementationsCodeLens = {
                enabled = true,
                showOnInterfaceMethods = true,
                showOnAllClassMethods = true,
              },
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

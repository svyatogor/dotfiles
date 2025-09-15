return {
  {
    "mini.hipatterns",
    opts = function(old, opts)
      table.insert(opts.tailwind.ft, 1, "ruby")
      table.insert(opts.tailwind.ft, 1, "eruby")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes_include = {
            "ruby",
            "eruby",
          },
        },
      },
      setup = {
        tailwindcss = function(_, opts)
          -- Get the default config and set up filetypes
          local tw = LazyVim.lsp.get_raw_config("tailwindcss")
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          -- Remove excluded filetypes
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Set up settings with both default and new languages
          opts.settings = {
            tailwindCSS = {
              includeLanguages = {
                -- Default LazyVim languages
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
                -- Your additional languages
                ruby = "html",
                eruby = "html",
              },
              experimental = {
                classRegex = {
                  -- Default patterns
                  "class:\\s*[\"']([^\"']*)[\"']",
                  "className:\\s*[\"']([^\"']*)[\"']",
                  -- Ruby hash syntax: class: "tailwind classes"
                  "class:\\s*[\"']([^\"']*)[\"']",
                  -- Ruby hash syntax with symbols: :class => "tailwind classes"
                  ":class\\s*=>\\s*[\"']([^\"']*)[\"']",
                },
              },
            },
          }

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },
}

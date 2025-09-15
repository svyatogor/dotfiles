return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      nil_ls = { enabled = false },
      nixd = {
        enabled = true,
        settings = {
          nix = {
            format = {
              enable = true,
            },
            lsp = {
              enable = true,
            },
          },
        },
      },
    },
  },
}

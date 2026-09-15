vim.pack.add { 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' }

require('tiny-inline-diagnostic').setup {
  options = {
    use_icons_from_diagnostic = true,
    set_arrow_to_diag_color = true,
  },
}

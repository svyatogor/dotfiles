-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"
vim.g.winborder = "rounded"
vim.g.snacks_animate = false

-- Include underscores and dashes in word boundaries for better snake_case/kebab-case handling
vim.opt.iskeyword:append("_")
vim.opt.iskeyword:append("-")
vim.opt_local.spell = false

vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"

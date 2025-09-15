-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center", noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center", noremap = true, silent = true })
vim.keymap.set(
  "n",
  "<leader>gvd",
  "<cmd>vsplit<CR><cmd>lua vim.lsp.buf.definition()<CR>",
  { desc = "Go to definition in vertical split", noremap = true, silent = true }
)

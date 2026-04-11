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

vim.keymap.set("v", "<leader>yf", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local ref = path .. ":" .. start_line .. "-" .. end_line
  vim.fn.setreg("+", ref)
  vim.notify(ref, vim.log.levels.INFO)
end, { desc = "Copy file reference with line range" })

vim.keymap.set("n", "<leader>yf", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local ref = path .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", ref)
  vim.notify(ref, vim.log.levels.INFO)
end, { desc = "Copy file reference with line" })

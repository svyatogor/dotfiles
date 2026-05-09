-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center", noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center", noremap = true, silent = true })

vim.keymap.set({ "n", "x" }, "<leader>cy", '"+y', { desc = "Yank to system clipboard (OSC)" })
vim.keymap.set("n", "<leader>cY", '"+Y', { desc = "Yank line to system clipboard (OSC)" })
vim.keymap.set({ "n", "x" }, "<leader>cp", '"+p', { desc = "Paste from system clipboard (OSC)" })
vim.keymap.set({ "n", "x" }, "<leader>cP", '"+P', { desc = "Paste before from system clipboard (OSC)" })

vim.keymap.set("n", "<leader>gs", function()
  local cur = vim.api.nvim_get_current_win()

  vim.lsp.buf.definition({
    on_list = function(opts)
      if not opts or not opts.items or vim.tbl_isempty(opts.items) then
        vim.notify("No definition found", vim.log.levels.INFO)
        return
      end

      vim.api.nvim_set_current_win(cur)

      vim.cmd("wincmd l")
      if vim.api.nvim_get_current_win() == cur then
        vim.cmd("vsplit")
      end

      vim.fn.setqflist({}, " ", opts)
      vim.cmd("cc 1")
      vim.cmd("cclose")
    end,
  })
end, { desc = "Goto Definition in Right Split" })

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

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Copy file reference with line range" })

vim.keymap.set("n", "<leader>yf", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local ref = path .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", ref)
  vim.notify(ref, vim.log.levels.INFO)
end, { desc = "Copy file reference with line" })

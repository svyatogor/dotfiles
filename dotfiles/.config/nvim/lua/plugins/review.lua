-- REVIEW comments are the code-review medium — I annotate, Claude addresses and deletes them.
-- The agent side lives in dotfiles/.agents/skills/address-review-comments (shared by claude + codex).

-- `range = true` hands us an ascending line1/line2 in normal mode, so there is no visual mode
-- to detect, no ends to swap, and no <Esc> to feed — which would have eaten the body being typed.
vim.api.nvim_create_user_command("ReviewAdd", function(opts)
  local from, to = opts.line1, opts.line2

  -- Above the code, at its indentation: keeps the reviewed line untouched and keeps the
  -- annotation a real comment, which `comments_only` needs to highlight and jump to it.
  local cs = vim.bo.commentstring
  if cs == "" then
    cs = "# %s" -- ponytail: ts-comments covers every real filetype; this is for the rest
  end
  local open, close = cs:match("^(.-)%%s(.-)$")
  local span = to > from and ("(L%d-%d) "):format(from, to) or ""
  local line = vim.fn.getline(from):match("^%s*") .. open .. "REVIEW: " .. span .. close
  vim.fn.append(from - 1, line)

  -- Completion popups over prose are noise; blink reads this buffer-local flag itself.
  local completion = vim.b.completion
  vim.b.completion = false

  -- Typing the body in insert mode beats a prompt, but an abandoned comment would still
  -- show up as an open review. Drop it if nothing was typed.
  vim.api.nvim_create_autocmd("InsertLeave", {
    buffer = 0,
    once = true,
    callback = function()
      vim.b.completion = completion
      if vim.fn.getline(from) == line then
        vim.api.nvim_buf_set_lines(0, from - 1, from, false, {})
      end
    end,
  })

  vim.api.nvim_win_set_cursor(0, { from, #line - #close }) -- clamped, then ignored, without a closer
  vim.cmd(close == "" and "startinsert!" or "startinsert")
end, { range = true, desc = "Add a REVIEW: comment above the line or selection" })

-- diffview builds its revision buffers with `buftype=nowrite`, which todo-comments skips
-- outright, so the left side of every diff loses its signs. Force-attach the diff windows.
vim.api.nvim_create_autocmd("User", {
  pattern = "DiffviewDiffBufWinEnter",
  callback = function()
    local hl = require("todo-comments.highlight")
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.wo[win].diff then
        hl.attach(win, true)
      end
    end
    hl.update() -- diffview reuses windows across files, so attach() alone would not repaint
  end,
})

return {
  {
    "folke/todo-comments.nvim",
    opts = { keywords = { REVIEW = { icon = "󰈈 ", color = "default" } } },
    -- Not behind a keymap, but `:TodoQuickFix keywords=REVIEW` is the way to `:cdo` over the
    -- list, and LazyVim only stubs TodoTrouble/TodoTelescope.
    cmd = { "TodoQuickFix" },
    -- stylua: ignore
    keys = {
      { "<leader>ra", ":ReviewAdd<CR>", mode = { "n", "x" }, desc = "Add review comment" },
      { "<leader>rl", "<cmd>Trouble todo toggle filter = {tag = {REVIEW}}<cr>", desc = "List review comments" },
      { "<leader>rs", function() Snacks.picker.todo_comments({ keywords = { "REVIEW" } }) end, desc = "Search review comments" },
      { "]r", function() require("todo-comments").jump_next({ keywords = { "REVIEW" } }) end, desc = "Next review comment" },
      { "[r", function() require("todo-comments").jump_prev({ keywords = { "REVIEW" } }) end, desc = "Previous review comment" },
    },
  },
}

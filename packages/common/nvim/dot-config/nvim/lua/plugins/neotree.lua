return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  opts = {
    event_handlers = {
      {
        event = "neo_tree_buffer_leave",
        handler = function()
          local shown_buffers = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            shown_buffers[vim.api.nvim_win_get_buf(win)] = true
          end
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if not shown_buffers[buf] and vim.bo[buf].buftype == "nofile" and vim.bo[buf].filetype == "neo-tree" then
              vim.api.nvim_buf_delete(buf, {})
            end
          end
        end,
      },
    },
  },
}

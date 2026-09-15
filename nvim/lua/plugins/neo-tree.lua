vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

local function root()
  local path = vim.api.nvim_buf_get_name(0)
  return vim.fs.root(path ~= '' and path or vim.uv.cwd(), '.git') or vim.uv.cwd()
end

local function toggle(source, dir) require('neo-tree.command').execute { source = source, toggle = true, dir = dir } end

require('neo-tree').setup {
  sources = { 'filesystem', 'git_status' },
  open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
  },
  window = {
    mappings = {
      ['l'] = 'open',
      ['h'] = 'close_node',
      ['<space>'] = 'none',
      ['Y'] = {
        function(state) vim.fn.setreg('+', state.tree:get_node():get_id(), 'c') end,
        desc = 'Copy Path to Clipboard',
      },
      ['O'] = {
        function(state) vim.ui.open(state.tree:get_node().path) end,
        desc = 'Open with System Application',
      },
      ['P'] = { 'toggle_preview', config = { use_float = false } },
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true,
      expander_collapsed = '',
      expander_expanded = '',
      expander_highlight = 'NeoTreeExpander',
    },
  },
  event_handlers = {
    {
      event = require('neo-tree.events').FILE_MOVED,
      handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end,
    },
    {
      event = require('neo-tree.events').FILE_RENAMED,
      handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end,
    },
    {
      event = require('neo-tree.events').NEO_TREE_BUFFER_LEAVE,
      handler = function()
        local shown_buffers = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          shown_buffers[vim.api.nvim_win_get_buf(win)] = true
        end
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if not shown_buffers[buf] and vim.bo[buf].buftype == 'nofile' and vim.bo[buf].filetype == 'neo-tree' then vim.api.nvim_buf_delete(buf, {}) end
        end
      end,
    },
  },
}

vim.keymap.set('n', '<leader>fe', function() toggle('filesystem', root()) end, { desc = 'Explorer NeoTree (Root Dir)' })
vim.keymap.set('n', '<leader>fE', function() toggle('filesystem', vim.uv.cwd()) end, { desc = 'Explorer NeoTree (cwd)' })
vim.keymap.set('n', '<leader>e', '<leader>fe', { desc = 'Explorer NeoTree (Root Dir)', remap = true })
vim.keymap.set('n', '<leader>E', '<leader>fE', { desc = 'Explorer NeoTree (cwd)', remap = true })
vim.keymap.set('n', '<leader>ge', function() toggle 'git_status' end, { desc = 'Git Explorer' })

vim.api.nvim_create_autocmd('TermClose', {
  pattern = '*lazygit',
  callback = function()
    if package.loaded['neo-tree.sources.git_status'] then require('neo-tree.sources.git_status').refresh() end
  end,
})

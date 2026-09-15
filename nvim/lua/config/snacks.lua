vim.pack.add { 'https://github.com/folke/snacks.nvim' }

local snacks = require 'snacks'

snacks.setup {
  animate = { enabled = false },
  bufdelete = { enabled = true },
  explorer = { enabled = false },
  indent = { enabled = true, animate = { enabled = false } },
  notifier = { enabled = false },
  picker = {
    enabled = true,
    ui_select = true,
    matcher = { frecency = true, history_bonus = true },
    layout = {
      preview = 'preview',
      preset = 'ivy',
    },
  },
  scratch = {
    enabled = true,
    ft = 'markdown',
    win = {
      position = 'right',
      height = 0,
      wo = {
        wrap = true,
        spell = false,
      },
    },
  },
  terminal = { enabled = true },
  words = { enabled = true },
  zen = {
    enabled = true,
    dim = false,
    git_signs = true,
    mini_diff_signs = true,
    zoom = {
      toggles = {},
      show = { statusline = true, tabline = true },
      win = {
        backdrop = { transparent = true, blend = 40 },
        width = 120,
      },
    },
  },
  scope = {},
}

snacks.toggle.diagnostics():map '<leader>ud'
snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
snacks
  .toggle({
    name = 'Indent Guides',
    get = function() return snacks.indent.enabled end,
    set = function(enabled)
      if enabled then
        snacks.indent.enable()
      else
        snacks.indent.disable()
      end
    end,
  })
  :map '<leader>ug'

local function map(keys, action, desc, mode, opts)
  if type(action) ~= 'function' then
    local callable = action
    action = function() callable() end
  end
  vim.keymap.set(mode or 'n', keys, action, vim.tbl_extend('force', { desc = desc }, opts or {}))
end

local function picker(keys, name, desc, opts, mode)
  map(keys, function() snacks.picker[name](opts) end, desc, mode)
end

picker('<leader><space>', 'smart', 'Smart Find Files')
picker('<leader>,', 'buffers', 'Buffers')
picker('<leader>/', 'grep', 'Grep')
picker('<leader>:', 'command_history', 'Command History')
picker('<leader>fb', 'buffers', 'Buffers')
picker('<leader>ff', 'files', 'Find Files')
picker('<leader>fg', 'git_files', 'Find Git Files')
picker('<leader>fp', 'projects', 'Projects')
picker('<leader>fr', 'recent', 'Recent')

picker('<leader>gb', 'git_branches', 'Git Branches')
picker('<leader>gl', 'git_log', 'Git Log')
picker('<leader>gL', 'git_log_line', 'Git Log Line')
picker('<leader>gs', 'git_status', 'Git Status')
picker('<leader>gS', 'git_stash', 'Git Stash')
picker('<leader>gd', 'git_diff', 'Git Diff (Hunks)')
picker('<leader>gf', 'git_log_file', 'Git Log File')

picker('<leader>gi', 'gh_issue', 'GitHub Issues (open)')
picker('<leader>gI', 'gh_issue', 'GitHub Issues (all)', { state = 'all' })
picker('<leader>gp', 'gh_pr', 'GitHub Pull Requests (open)')
picker('<leader>gP', 'gh_pr', 'GitHub Pull Requests (all)', { state = 'all' })

picker('<leader>sB', 'grep_buffers', 'Grep Open Buffers')
picker('<leader>sw', 'grep_word', 'Visual Selection or Word', nil, { 'n', 'x' })

picker('<leader>s"', 'registers', 'Registers')
picker('<leader>s/', 'search_history', 'Search History')
picker('<leader>sc', 'command_history', 'Command History')
picker('<leader>sC', 'commands', 'Commands')
picker('<leader>sd', 'diagnostics', 'Diagnostics')
picker('<leader>sD', 'diagnostics_buffer', 'Buffer Diagnostics')
picker('<leader>sh', 'help', 'Help Pages')
picker('<leader>sH', 'highlights', 'Highlights')
picker('<leader>si', 'icons', 'Icons')
picker('<leader>sj', 'jumps', 'Jumps')
picker('<leader>sk', 'keymaps', 'Keymaps')
picker('<leader>sl', 'loclist', 'Location List')
picker('<leader>sm', 'marks', 'Marks')
picker('<leader>sq', 'qflist', 'Quickfix List')
picker('<leader>sR', 'resume', 'Resume')
picker('<leader>su', 'undo', 'Undo History')

picker('gd', 'lsp_definitions', 'Goto Definition')
picker('gD', 'lsp_declarations', 'Goto Declaration')
map('gr', function() snacks.picker.lsp_references() end, 'References', 'n', { nowait = true })
picker('gI', 'lsp_implementations', 'Goto Implementation')
picker('gy', 'lsp_type_definitions', 'Goto Type Definition')
picker('gai', 'lsp_incoming_calls', 'Calls Incoming')
picker('gao', 'lsp_outgoing_calls', 'Calls Outgoing')
picker('<leader>ss', 'lsp_symbols', 'LSP Symbols')
picker('<leader>sS', 'lsp_workspace_symbols', 'LSP Workspace Symbols')

map('<leader>uz', snacks.zen.zoom, 'Toggle Zoom')
map('<leader>.', snacks.scratch, 'Toggle Scratch Buffer')
map('<leader>S', snacks.scratch.select, 'Select Scratch Buffer')
map('<leader>bd', snacks.bufdelete, 'Delete Buffer')
map('<leader>cR', snacks.rename.rename_file, 'Rename File')
map('<c-/>', snacks.terminal, 'Toggle Terminal')
map(']]', function() snacks.words.jump(vim.v.count1) end, 'Next Reference', { 'n', 't' })
map('[[', function() snacks.words.jump(-vim.v.count1) end, 'Prev Reference', { 'n', 't' })

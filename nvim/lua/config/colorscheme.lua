vim.pack.add { { src = 'https://github.com/tanmaymanojgandhi/circadia', name = 'circadia' } }
-- ponytail: port lives in a subdir, so put it on rtp instead of generating colors/ files
vim.opt.rtp:append(vim.pack.get({ 'circadia' })[1].path .. '/ports/neovim')
require('circadia').setup { mode = 'light' }

-- The port defines no diff groups and setup() takes no overrides, so Neovim's stock NvimLight*
-- colours leak through. Roles follow Circadia's VS Code port (added = string, changed = number),
-- except deleted: the port hardcodes #dc2626 (fails AAA on canvas); ANSI red maps to type instead.
-- Tints are that role blended over bg_canvas (10% line, 25% changed text), matching delta.
-- No fg on line groups, so syntax colours survive. Loaded before diffview, which copies
-- DiffDelete into DiffviewDiffAddAsDelete, so DiffDelete stays bg-only.
local c = require('circadia.palette').light
local destructive = '#dc2626' -- VS Code port's errorForeground; not in the palette
for group, hl in pairs {
  DiffAdd = { bg = '#dee3d4' },
  DiffChange = { bg = c.bg_element },
  DiffText = { bg = '#b9c8d9' }, -- keyword 25%
  DiffTextAdd = { bg = '#b9cdb8' },
  DiffDelete = { bg = '#ece0cf' },
  Added = { fg = c.string },
  Changed = { fg = c.number },
  Removed = { fg = c.type },
  GitSignsAddInline = { bg = '#b9cdb8' },
  GitSignsChangeInline = { bg = '#b9c8d9' },
  GitSignsDeleteInline = { bg = '#dac4ad' },
  SignColumn = { fg = c.text_faint },
  Folded = { fg = c.text_muted, bg = c.bg_surface },

  -- Also undefined by the port, so stock NvimDark*/NvimLight* leak (and mini.icons links to them).
  -- Values again follow the VS Code port; NonText per token-map §1.
  Directory = { fg = c.accent }, -- same blue as eza/yazi directories
  NonText = { fg = c.text_faint },
  Conceal = { fg = c.text_faint },
  SnacksIndent = { fg = c.border }, -- port's editorIndentGuide.background; NonText is too dark for guides
  Title = { fg = c.h1, bold = true },
  WinBar = { fg = c.text_primary, bold = true },
  WinBarNC = { fg = c.text_muted },
  DiagnosticError = { fg = destructive },
  DiagnosticWarn = { fg = c.number }, -- port's warningColor
  DiagnosticInfo = { fg = c.keyword },
  DiagnosticHint = { fg = c.text_muted },
  DiagnosticOk = { fg = c.string },
  DiagnosticUnderlineError = { sp = destructive, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.number, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.keyword, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.text_muted, undercurl = true },
  DiagnosticUnderlineOk = { sp = c.string, undercurl = true },
  DiagnosticDeprecated = { sp = c.text_faint, strikethrough = true },
  MiniIconsAzure = { fg = c.h4 },
  MiniIconsBlue = { fg = c.keyword },
  MiniIconsCyan = { fg = c.number },
  MiniIconsGreen = { fg = c.string },
  MiniIconsGrey = { fg = c.text_muted },
  MiniIconsOrange = { fg = c.type },
  MiniIconsPurple = { fg = c.property },
  MiniIconsRed = { fg = destructive },
  MiniIconsYellow = { fg = c.type },

  -- neo-tree ships hardcoded dark-theme greys and #ff8700; it only sets `highlight default`, so these win.
  NeoTreeGitUntracked = { fg = c.string },
  NeoTreeGitUnstaged = { link = 'NeoTreeGitModified' },
  NeoTreeGitDeleted = { fg = destructive },
  NeoTreeGitConflict = { fg = destructive, bold = true },
  NeoTreeGitIgnored = { fg = c.text_faint },
  NeoTreeDotfile = { fg = c.text_faint },
  NeoTreeDimText = { fg = c.border }, -- port's tree.indentGuidesStroke; indent markers and expanders link here
  NeoTreeFadeText1 = { fg = c.text_muted },
  NeoTreeFadeText2 = { fg = c.text_faint },
  NeoTreeModified = { fg = c.number },
  NeoTreeMessage = { fg = c.comment, italic = true },
  NeoTreeFileStats = { fg = c.text_muted },
  NeoTreeFileStatsHeader = { fg = c.text_muted, bold = true },
  NeoTreeTabInactive = { fg = c.text_muted, bg = c.bg_surface },
  NeoTreeTabSeparatorActive = { fg = c.border },
  NeoTreeTabSeparatorInactive = { fg = c.border, bg = c.bg_surface },
} do
  vim.api.nvim_set_hl(0, group, hl)
end

local M = {}

local DEFAULT_THEME = "base16-oceanicnext"

local function is_blank(value)
  return value == nil or value == ""
end

local function get_tinty_theme()
  if vim.fn.executable("tinty") ~= 1 then
    return DEFAULT_THEME
  end

  local theme_name = vim.fn.system({ "tinty", "current" })
  if vim.v.shell_error ~= 0 then
    return DEFAULT_THEME
  end

  local trimmed = vim.trim(theme_name)
  if is_blank(trimmed) then
    return DEFAULT_THEME
  end

  return string.gsub(trimmed, "base24", "base16")
end

local function apply_colorscheme(theme)
  if vim.g.colors_name == theme then
    return true
  end

  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if ok then
    return true
  end

  vim.schedule(function()
    vim.notify(string.format("tinty theme '%s' failed to load (%s)", theme, err), vim.log.levels.WARN)
  end)
  return false
end

local function update()
  local theme = get_tinty_theme()
  if apply_colorscheme(theme) then
    return vim.g.colors_name
  end

  if theme ~= DEFAULT_THEME and apply_colorscheme(DEFAULT_THEME) then
    return vim.g.colors_name
  end

  return vim.g.colors_name
end

local function setup_autocmds()
  if M._augroup then
    return
  end

  M._augroup = vim.api.nvim_create_augroup("LazyVimTintyTheme", { clear = true })

  vim.api.nvim_create_autocmd("FocusGained", {
    group = M._augroup,
    callback = update,
  })

  vim.api.nvim_create_autocmd("User", {
    group = M._augroup,
    pattern = "LazyVimStarted",
    callback = update,
  })
end

function M.apply()
  vim.o.termguicolors = true
  vim.g.tinted_colorspace = 256

  setup_autocmds()
  return update()
end

return M

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Function to check if a command exists
local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Function to check Ruby version (returns true if Ruby >= 3.0)
local function ruby_version_sufficient()
  if not command_exists("ruby") then
    return false
  end

  local ruby_version_output = vim.fn.system("ruby --version"):gsub("%s+", "")
  if ruby_version_output == "" then
    return false
  end

  -- Parse version string from output like "ruby 3.2.0 (2022-12-25 revision [a54090ba0])"
  local major_version = tonumber(ruby_version_output:match("ruby (%d+)%."))
  return major_version and major_version >= 3
end

-- Function to check if a language/tool is installed
local function check_language_extras()
  local extras = {}

  -- Language-specific checks
  if command_exists("node") then
    table.insert(extras, { import = "lazyvim.plugins.extras.lang.typescript" })
    table.insert(extras, { import = "lazyvim.plugins.extras.formatting.prettier" })
    table.insert(extras, { import = "lazyvim.plugins.extras.linting.eslint" })
    table.insert(extras, { import = "lazyvim.plugins.extras.lang.tailwind" })
  end

  if ruby_version_sufficient() then
    table.insert(extras, { import = "lazyvim.plugins.extras.lang.ruby" })
  end

  if command_exists("rustc") or command_exists("cargo") then
    table.insert(extras, { import = "lazyvim.plugins.extras.lang.rust" })
  end

  if command_exists("cmake") then
    table.insert(extras, { import = "lazyvim.plugins.extras.lang.cmake" })
  end

  -- Check for solidity
  if command_exists("solc") then
    table.insert(extras, { import = "lazyvim.plugins.extras.lang.solidity" })
  end

  return extras
end

local function build_spec()
  local spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  }

  -- add conditionally loaded language extras
  local language_extras = check_language_extras()
  for _, extra in ipairs(language_extras) do
    table.insert(spec, extra)
  end

  -- import/override with your plugins (last)
  table.insert(spec, { import = "plugins" })

  return spec
end

require("lazy").setup({
  spec = build_spec(),
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

LazyVim-based Neovim configuration with conditional plugin loading based on installed tools.

## Architecture

```
lua/
├── config/           # Core config (lazy.lua, options.lua, keymaps.lua, autocmds.lua)
└── plugins/          # One file per plugin/feature (28 files)
after/queries/        # Treesitter query overrides
```

**Key pattern**: Plugin specs in individual files under `lua/plugins/`. Each file returns a table or array of plugin specs.

## Plugin Configuration Patterns

**Simple opts override:**
```lua
return { "plugin/name", opts = { option = value } }
```

**Extend existing opts:**
```lua
return {
  "plugin/name",
  opts = function(_, opts)
    table.insert(opts.list, item)
    return opts
  end
}
```

**LSP server config:**
```lua
return {
  "neovim/nvim-lspconfig",
  opts = { servers = { server_name = { config } } }
}
```

## Smart Loading

`lua/config/lazy.lua` conditionally enables LazyVim extras based on installed tools:
- Node.js → TypeScript, Prettier, ESLint, Tailwind
- Ruby >= 3.0 → Ruby extras
- Rust/Cargo → Rust extras
- CMake, Solidity similarly gated

## Key Customizations

- **AI**: claudecode.nvim, ai-commit-msg.nvim (Gemini), opencode.nvim
- **LSP choices**: ruby_lsp (not solargraph), tsgo (not tsserver), nixd (not nil_ls)
- **Remote support**: OSC 52 clipboard, transparent backgrounds
- **Theme**: External loader from `~/.local/share/theme/nvim.lua`
- **Ruby/ERB**: Tailwind CSS class completion via custom regex

## Important Files

| File | Purpose |
|------|---------|
| `lazyvim.json` | LazyVim extras manifest |
| `lua/config/lazy.lua` | Bootstrap + conditional loading logic |
| `lua/config/options.lua` | Vim options, LSP choices, theme settings |
| `lua/plugins/ai.lua` | Claude Code + AI commit integration |
| `lua/plugins/ruby.lua` | Ruby LSP + Tailwind config |
| `lua/plugins/typescript.lua` | TypeScript LSP routing (tsgo) |

## Commands

Format Lua: `stylua .` (config in stylua.toml)

Check plugin health: `:checkhealth lazy`

Sync plugins: `:Lazy sync` (or restart nvim)

## Notes

- Bufferline disabled in `lua/plugins/common.lua`
- Snacks animations disabled in options.lua
- `<leader>ac` toggles Claude Code window

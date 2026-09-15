vim.pack.add { 'https://github.com/neovim/nvim-lspconfig', 'https://github.com/b0o/SchemaStore.nvim' }

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('fzf-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    local fzf = require 'fzf-lua'

    vim.keymap.set('n', 'grr', fzf.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gri', fzf.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'grd', fzf.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
    vim.keymap.set('n', 'gW', fzf.lsp_live_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
    vim.keymap.set('n', 'grt', fzf.lsp_typedefs, { buffer = buf, desc = '[G]oto [T]ype Definition' })
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle Inlay Hints')
    end
  end,
})

---@type table<string, vim.lsp.Config>
local servers = {
  tsc = {
    cmd = { 'mise', 'exec', 'npm:typescript@7', '--', 'tsc', '--lsp', '--stdio' },
    -- We force TS7 above; the built-in root detector rejects an older or missing local/PATH `tsc` first.
    root_dir = function(bufnr, on_dir) on_dir(vim.fs.root(bufnr, { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }) or vim.fn.getcwd()) end,
    settings = {
      ['js/ts'] = {
        inlayHints = {
          parameterNames = {
            enabled = 'literals',
            suppressWhenArgumentMatchesName = true,
          },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = false },
          enumMemberValues = { enabled = true },
        },
        referencesCodeLens = {
          enabled = true,
          showOnAllFunctions = true,
        },
        implementationsCodeLens = {
          enabled = true,
          showOnInterfaceMethods = true,
          showOnAllClassMethods = true,
        },
      },
    },
  },
  eslint = {
    settings = {
      run = 'onType',
    },
  },
  tailwindcss = {
    -- `eruby` is already supported by nvim-lspconfig's default Tailwind config.
    filetypes = vim.list_extend(vim.deepcopy(vim.lsp.config.tailwindcss.filetypes), { 'ruby' }),
    settings = {
      tailwindCSS = {
        includeLanguages = {
          ruby = 'html',
          eruby = 'html',
        },
        experimental = {
          classRegex = {
            'class:\\s*["\']([^"\']*)["\']',
            'className:\\s*["\']([^"\']*)["\']',
            ':class\\s*=>\\s*["\']([^"\']*)["\']',
          },
        },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },
  stylua = {},
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
      client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file('', true),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false },
      },
    },
  },
}

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

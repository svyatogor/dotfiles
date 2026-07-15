return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-jest",
  },
  opts = function(_, opts)
    opts.adapters = opts.adapters or {}

    -- Walk up from a file to find the nearest project root
    local function find_root(path, markers)
      local found = vim.fs.find(markers, {
        upward = true,
        path = vim.fs.dirname(path),
      })[1]
      return found and vim.fs.dirname(found) or nil
    end

    table.insert(
      opts.adapters,
      require("neotest-jest")({
        jestCommand = function(path)
          local root = find_root(path, {
            "pnpm-lock.yaml", "yarn.lock", "package-lock.json", "package.json",
          })
          if not root then return "npx jest" end

          if vim.uv.fs_stat(root .. "/pnpm-lock.yaml") then
            return "pnpm exec jest"
          elseif vim.uv.fs_stat(root .. "/yarn.lock") then
            return "yarn jest"
          elseif vim.uv.fs_stat(root .. "/package-lock.json") then
            return "npx jest"
          end
          return "npx jest"
        end,

        jestConfigFile = function(path)
          local root = find_root(path, { "package.json" })
          if not root then return nil end

          for _, name in ipairs({
            "jest.config.ts", "jest.config.js",
            "jest.config.mjs", "jest.config.cjs",
            "jest.config.json",
          }) do
            if vim.uv.fs_stat(root .. "/" .. name) then
              return root .. "/" .. name
            end
          end
          -- Falls back to jest config inside package.json
          return root .. "/package.json"
        end,

        cwd = function(path)
          return find_root(path, { "package.json" }) or vim.fn.getcwd()
        end,

        isTestFile = function(file_path)
          return file_path:match("%.spec%.[tj]sx?$")
            or file_path:match("%.test%.[tj]sx?$")
        end,

        env = { CI = "true" },
      })
    )
  end,
}

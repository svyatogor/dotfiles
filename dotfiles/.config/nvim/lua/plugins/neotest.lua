return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-jest",
    "olimorris/neotest-rspec",
  },
  opts = {
    floating = { border = "rounded" },
    adapters = {
      ["neotest-rspec"] = {
        root_files = { "Gemfile", "gems.rb", "*.gemspec", ".rspec", ".git", ".gitignore", "bin/rails" },
        rspec_cmd = function()
          local bin = vim.fn.getcwd() .. "/bin/rspec"
          return vim.fn.executable(bin) == 1 and { bin } or { "bundle", "exec", "rspec" }
        end,
      },
      ["neotest-jest"] = {
        jestCommand = function(path)
          local project = vim.fs.root(path, { "pnpm-lock.yaml", "yarn.lock", "package-lock.json", "package.json" })

          if project and vim.uv.fs_stat(project .. "/pnpm-lock.yaml") then
            return "pnpm exec jest"
          end
          if project and vim.uv.fs_stat(project .. "/yarn.lock") then
            return "yarn jest"
          end
          return "npx jest"
        end,
        jestConfigFile = function(path)
          local project = vim.fs.root(path, "package.json")
          if not project then
            return nil
          end

          for _, config in ipairs({ "ts", "js", "mjs", "cjs", "json" }) do
            local file = project .. "/jest.config." .. config
            if vim.uv.fs_stat(file) then
              return file
            end
          end

          return project .. "/package.json"
        end,
        cwd = function(path)
          return vim.fs.root(path, "package.json") or vim.fn.getcwd()
        end,
        isTestFile = function(path)
          return path:match("%.spec%.[tj]sx?$") or path:match("%.test%.[tj]sx?$")
        end,
        env = { CI = "true" },
      },
    },
  },
}

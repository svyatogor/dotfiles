local function resolve_rspec_cmd(root)
  if root then
    local bin_rspec = root .. "/bin/rspec"
    if vim.fn.executable(bin_rspec) == 1 then
      return { bin_rspec }
    end
  end

  return { "bundle", "exec", "rspec" }
end

local function find_root(path, markers)
  local found = vim.fs.find(markers, {
    upward = true,
    path = vim.fs.dirname(path),
  })[1]

  return found and vim.fs.dirname(found) or nil
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-jest",
    "olimorris/neotest-rspec",
  },
  init = function()
    vim.api.nvim_create_user_command("NeotestRspecDebug", function()
      local ok, adapter = pcall(require, "neotest-rspec")
      if not ok then
        vim.notify("neotest-rspec is not loaded", vim.log.levels.ERROR, { title = "Neotest RSpec Debug" })
        return
      end

      local path = vim.api.nvim_buf_get_name(0)
      local cwd = vim.uv.cwd()
      local probe_path = path ~= "" and path or cwd
      local root = adapter.root(probe_path)
      local is_test = path ~= "" and adapter.is_test_file(path) or false
      local cmd = table.concat(resolve_rspec_cmd(root), " ")

      vim.notify(
        table.concat({
          "file: " .. (path ~= "" and path or "<none>"),
          "filetype: " .. vim.bo.filetype,
          "cwd: " .. cwd,
          "root: " .. (root or "<none>"),
          "is_test_file: " .. tostring(is_test),
          "rspec_cmd: " .. cmd,
        }, "\n"),
        vim.log.levels.INFO,
        { title = "Neotest RSpec Debug" }
      )
    end, { desc = "Show neotest-rspec root and file detection info" })
  end,
  opts = function(_, opts)
    opts.floating = vim.tbl_deep_extend("force", opts.floating or {}, {
      border = "rounded",
    })

    opts.adapters = opts.adapters or {}
    opts.adapters["neotest-rspec"] = vim.tbl_deep_extend("force", opts.adapters["neotest-rspec"] or {}, {
      root_files = {
        "Gemfile",
        "gems.rb",
        "*.gemspec",
        ".rspec",
        ".git",
        ".gitignore",
        "bin/rails",
      },
      rspec_cmd = function()
        return resolve_rspec_cmd(vim.fn.getcwd())
      end,
    })

    opts.adapters["neotest-jest"] = vim.tbl_deep_extend("force", opts.adapters["neotest-jest"] or {}, {
      jestCommand = function(path)
        local root = find_root(path, {
          "pnpm-lock.yaml",
          "yarn.lock",
          "package-lock.json",
          "package.json",
        })

        if not root then
          return "npx jest"
        end
        if vim.uv.fs_stat(root .. "/pnpm-lock.yaml") then
          return "pnpm exec jest"
        end
        if vim.uv.fs_stat(root .. "/yarn.lock") then
          return "yarn jest"
        end

        return "npx jest"
      end,
      jestConfigFile = function(path)
        local root = find_root(path, { "package.json" })
        if not root then
          return nil
        end

        for _, name in ipairs({
          "jest.config.ts",
          "jest.config.js",
          "jest.config.mjs",
          "jest.config.cjs",
          "jest.config.json",
        }) do
          if vim.uv.fs_stat(root .. "/" .. name) then
            return root .. "/" .. name
          end
        end

        return root .. "/package.json"
      end,
      cwd = function(path)
        return find_root(path, { "package.json" }) or vim.fn.getcwd()
      end,
      isTestFile = function(file_path)
        return file_path:match("%.spec%.[tj]sx?$") or file_path:match("%.test%.[tj]sx?$")
      end,
      env = { CI = "true" },
    })
  end,
}

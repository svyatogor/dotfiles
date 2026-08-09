return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local started = false
    local clients = {}
    local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

    local function codecompanion_status()
      if not started then
        local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

        vim.api.nvim_create_autocmd({ "User" }, {
          pattern = "CodeCompanionRequest*",
          group = group,
          callback = function(request)
            if request.match == "CodeCompanionRequestStarted" then
              clients[request.buf] = true
            elseif request.match == "CodeCompanionRequestFinished" then
              clients[request.buf] = nil
            end
          end,
        })

        started = true
      end

      if not vim.tbl_isempty(clients) then
        local ms = vim.loop.hrtime() / 1000000
        local frame = math.floor(ms / 120) % #spinners
        return spinners[frame + 1]
      end

      return nil
    end

    -- Add codecompanion status to lualine_x section (before other components)
    table.insert(opts.sections.lualine_x, 1, {
      codecompanion_status,
      cond = function()
        return codecompanion_status() ~= nil
      end,
    })

    return opts
  end,
}

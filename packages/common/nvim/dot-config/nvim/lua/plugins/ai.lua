-- Helper function to get API key from env var or 1Password
local function get_api_key(env_var, op_reference)
  -- First, check if environment variable is set
  local env_value = vim.fn.getenv(env_var)
  if env_value ~= vim.NIL and env_value ~= "" then
    return env_var
  end

  -- If not set, check if op CLI is available
  if vim.fn.executable("op") == 1 then
    return "cmd:op read " .. op_reference .. " --no-newline"
  end

  -- No env var and no op CLI, return empty string
  return ""
end

return {
  {
    "coder/claudecode.nvim",
    opts = {},
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    keys = {
      { "<leader>c", group = "CodeCompanion" },
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle chat" },
      { "<leader>ci", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline assist" },
      { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Actions" },
      { "<leader>cq", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "Quick chat" },
      { "<leader>ct", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to chat" },
    },
    opts = {
      strategies = {
        chat = {
          adapter = "claude_code",
        },
        inline = {
          adapter = "openai",
        },
      },
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "gpt-5-mini",
              },
            },
            env = {
              api_key = get_api_key("OPENAI_API_KEY", "op://Keys/OPENAI_API_KEY/credential"),
            },
          })
        end,
        http = {
          openai_responses = function()
            return require("codecompanion.adapters").extend("openai_responses", {
              env = {
                api_key = get_api_key("OPENAI_API_KEY", "op://Keys/OPENAI_API_KEY/credential"),
              },
            })
          end,
        },
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = get_api_key(
                  "CLAUDE_CODE_SESSION",
                  "op://Keys/CLAUDE_CODE_SESSION/credential"
                ),
              },
            })
          end,
          codex = function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "openai-api-key", -- "openai-api-key"|"codex-api-key"|"chatgpt"
              },
              env = {
                OPENAI_API_KEY = get_api_key("OPENAI_API_KEY", "op://Keys/OPENAI_API_KEY/credential"),
              },
            })
          end,
        },
      },
    },
  },
}

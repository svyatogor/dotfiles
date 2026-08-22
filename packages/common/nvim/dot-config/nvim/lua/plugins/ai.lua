-- Plugin configuration for AI-related tools
-- This block defines plugins and their dependencies used by Neovim
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = {
          on_attach = function(client, bufnr)
            if vim.bo[bufnr].filetype == "markdown" then
              vim.schedule(function()
                vim.lsp.buf_detach_client(bufnr, client.id)
              end)
            end
          end,
        },
      },
    },
  },
  {
    "svyatogor/ai-commit-msg.nvim",
    ft = "gitcommit",
    opts = {
      auto_push_prompt = false,
      pull_before_push = {
        enabled = false,
      },
      spinner = true,
      notifications = true,
      provider = (vim.env.GEMINI_API_KEY and #vim.env.GEMINI_API_KEY > 0) and "gemini" or "claude_code",
      providers = {
        claude_code = {
          model = "sonnet",
        },
        gemini = {
          model = "gemini-3-flash-preview",
          temperature = 0.3,
          max_tokens = 4000,
          pricing = {
            ["gemini-3-flash-preview"] = {
              input_per_million = 0.10, -- Cost per million input tokens
              output_per_million = 0.40, -- Cost per million output tokens
            },
          },
        },
      },
    },
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    -- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
    -- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
    -- spec defers loading until a <leader>a* mapping is pressed and the commands
    -- would not exist yet.
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    "retran/meow.review.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    config = function()
      require("meow.review").setup({
        -- Your custom configuration goes here
      })
    end,
    keys = {
      { "<leader>ra", "<Plug>(MeowReviewAdd)", mode = { "n", "v" }, desc = "Add Review Comment" },
      { "<leader>rd", "<Plug>(MeowReviewDelete)", mode = { "n", "v" }, desc = "Delete Review Comment" },
      { "<leader>re", "<Plug>(MeowReviewEdit)", desc = "Edit Review Comment" },
      { "<leader>rv", "<Plug>(MeowReviewView)", desc = "View Review Comment" },
      { "<leader>rE", "<Plug>(MeowReviewExport)", desc = "Export Review" },
      { "<leader>rX", "<Plug>(MeowReviewExportAndClear)", desc = "Export and Clear" },
      { "<leader>rf", "<Plug>(MeowReviewExportFile)", desc = "Export Current File" },
      { "<leader>rc", "<Plug>(MeowReviewClear)", desc = "Clear All Comments" },
      { "<leader>rg", "<Plug>(MeowReviewGoto)", desc = "Go to Review Comment" },
      { "<leader>rG", "<Plug>(MeowReviewGotoFile)", desc = "Go to Comment in File" },
      { "<leader>rt", "<Plug>(MeowReviewGotoType)", desc = "Go to Comment by Type" },
      { "<leader>rR", "<Plug>(MeowReviewResolve)", desc = "Resolve Comment" },
      { "<leader>rA", "<Plug>(MeowReviewResolveAll)", desc = "Resolve All Comments" },
      { "<leader>rr", "<Plug>(MeowReviewReload)", desc = "Reload Review" },
      { "]r", "<Plug>(MeowReviewNext)", desc = "Next Review Comment" },
      { "[r", "<Plug>(MeowReviewPrev)", desc = "Previous Review Comment" },
    },
  },
}

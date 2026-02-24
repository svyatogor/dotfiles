-- Plugin configuration for AI-related tools
-- This block defines plugins and their dependencies used by Neovim
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
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
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  -- Core AI plugin providing opencode integration
  {
    "sudo-tee/opencode.nvim",
    opts = {},
    -- Dependencies required by opencode.nvim
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Plugin used to render enhanced Markdown and opencode outputs
      {
        "MeanderingProgrammer/render-markdown.nvim",
        -- Configuration for markdown rendering behavior
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "markdown", "opencode_output" },
        },
        ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
      },
    },
  },
  {
    dir = "svyatogor/ai-commit-msg.nvim",
    ft = "gitcommit",
    config = true,
    opts = {
      auto_push_prompt = false,
      pull_before_push = {
        enabled = false,
      },
      spinner = true,
      notifications = true,
      providers = {
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
}

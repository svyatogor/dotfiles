-- Plugin configuration for AI-related tools
-- This block defines plugins and their dependencies used by Neovim
return {
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
    "aweis89/ai-commit-msg.nvim",
    ft = "gitcommit",
    config = true,
    opts = {
      auto_push_prompt = false,
      pull_before_push = {
        enabled = false,
      },
      notifications = false,
      providers = {
        gemini = {
          model = "gemini-2.5-flash",
          temperature = 0.3,
          max_tokens = 4000,
          pricing = {
            ["gemini-2.5-flash"] = {
              input_per_million = 0.10, -- Cost per million input tokens
              output_per_million = 0.40, -- Cost per million output tokens
            },
          },
        },
      },
    },
  },
}

-- Plugin configuration for AI-related tools
-- This block defines plugins and their dependencies used by Neovim
return {
  {
    "svyatogor/ai-commit-msg.nvim",
    ft = "gitcommit",
    config = true,
    opts = {
      auto_push_prompt = false,
      pull_before_push = {
        enabled = false,
      },
      spinner = true,
      notifications = true,
      provider = "claude_code",
      providers = {
        claude_code = {
          model = "sonnet",
        },
        --   gemini = {
        --     model = "gemini-3-flash-preview",
        --     temperature = 0.3,
        --     max_tokens = 4000,
        --     pricing = {
        --       ["gemini-3-flash-preview"] = {
        --         input_per_million = 0.10, -- Cost per million input tokens
        --         output_per_million = 0.40, -- Cost per million output tokens
        --       },
        --     },
        --   },
      },
    },
  },
}

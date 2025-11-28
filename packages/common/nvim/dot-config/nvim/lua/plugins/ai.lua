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
}

vim.pack.add { 'https://github.com/svyatogor/ai-commit-msg.nvim' }

require('ai_commit_msg').setup {
  auto_push_prompt = false,
  pull_before_push = {
    enabled = false,
  },
  spinner = true,
  notifications = true,
  provider = (vim.env.GEMINI_API_KEY and #vim.env.GEMINI_API_KEY > 0) and 'gemini' or 'claude_code',
  providers = {
    claude_code = {
      model = 'sonnet',
    },
    gemini = {
      model = 'gemini-3-flash-preview',
      temperature = 0.3,
      max_tokens = 4000,
      pricing = {
        ['gemini-3-flash-preview'] = {
          input_per_million = 0.10,
          output_per_million = 0.40,
        },
      },
    },
  },
}

vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  heading = {
    sign = true,
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
  },
  checkbox = { enabled = true },
  indent = { enabled = true },
  pipe_table = {
    style = 'normal',
  },
}

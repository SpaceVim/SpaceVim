local job = require('spacevim.api.job')

job.start({ 'cat', '--version' }, {
  on_stdout = function(id, data, event)
    vim.print(id)
    vim.print(data)
    vim.print(event)
  end,
  on_exit = function(id, code, singin)
    vim.print(id)
    vim.print(data)
    vim.print(event)
  end,
})

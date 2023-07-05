local job = require('spacevim.api.job')

job.start({ 'vim', '--version' }, {
  on_stdout = function(id, data, event)
    vim.print(id)
    vim.print(data)
    vim.print(event)
  end,
  on_exit = function(id, code, signal)
    vim.print(id)
    vim.print('exit code', code)
    vim.print('exit signal', signal)
  end,
})

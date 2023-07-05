local job = require('spacevim.api.job')

local jobid = job.start('echo 1', {
  on_stdout = function(id, data, event)
    vim.print(id)
    vim.print(vim.inspect(data))
    vim.print(event)
  end,
  on_stderr = function(id, data, event)
    vim.print(id)
    vim.print(vim.inspect(data))
    vim.print(event)
  end,
  on_exit = function(id, code, signal)
    vim.print(id)
    vim.print('exit code', code)
    vim.print('exit signal', signal)
  end,
})


-- job.send(jobid, 'hello world')
-- job.stop(jobid)

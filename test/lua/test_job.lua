local job = require('spacevim.api.job')

local jobid = job.start({'lua53', '-'}, {
  on_stdout = function(id, data)
    vim.print(id)
    vim.print(vim.inspect(data))
  end,
  on_stderr = function(id, data)
    vim.print(id)
    vim.print(vim.inspect(data))
  end,
  on_exit = function(id, code, signal)
    vim.print(id)
    vim.print('exit code', code)
    vim.print('exit signal', signal)
  end,
})


job.send(jobid, 'print(1)\n')
job.send(jobid, 'print(1)\n')
job.send(jobid, 'print(1)\n')
job.send(jobid, 'print(1)\n')
job.chanclose(jobid, 'stdin')
job.stop(jobid)

local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local push_jobid = -1
local stderr_data = {}

local function on_stdout(id, data)
  if id ~= push_jobid then
    return
  end
  for _, line in pairs(data) do
    nt.notify_max_width = vim.fn.max({ vim.fn.strwidth(line) + 5, nt.notify_max_width })
    nt.notify(line)
  end
end

local function on_stderr(id, data)
  if id ~= push_jobid then
    return
  end
  for _, line in pairs(data) do
    table.insert(stderr_data, line)
  end
end

local function on_exit(id, code, single)
  log.debug('push code:' .. code .. ' single:' .. single)
  if id ~= push_jobid then
    return
  end
  if code == 0 and single == 0 then
    for _, line in ipairs(stderr_data) do
      nt.notify(line)
    end
  else
    for _, line in ipairs(stderr_data) do
      nt.notify(line, 'WarningMsg')
    end
  end
  push_jobid = -1
end

function M.run(argv)
  if push_jobid ~= -1 then
    nt.notify('previous push not finished')
  end

  nt.notify_max_width = vim.fn.float2nr(vim.o.columns * 0.3)

  stderr_data = {}

  local cmd = { 'git', 'push' }

  if argv then
    for _, v in ipairs(argv) do
      table.insert(cmd, v)
    end
  end
  log.debug(vim.inspect(cmd))
  push_jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })

  if push_jobid == -1 then
    nt.notify('`git` is not executable')
  end
end

function M.complete(ArgLead, CmdLine, CursorPos) end

return M

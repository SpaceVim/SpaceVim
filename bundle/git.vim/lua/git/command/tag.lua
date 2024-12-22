local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local tag_jobid = -1
local stderr_data = {}

local function on_stdout(id, data)
  if id ~= tag_jobid then
    return
  end
  for _, line in pairs(data) do
    nt.notify_max_width = vim.fn.max({ vim.fn.strwidth(line) + 5, nt.notify_max_width })
    nt.notify(line)
  end
end

local function on_stderr(id, data)
  if id ~= tag_jobid then
    return
  end
  for _, line in pairs(data) do
    table.insert(stderr_data, line)
  end
end

local function on_exit(id, code, single)
  log.debug('tag exit code:' .. code .. ' single:' .. single)
  if id ~= tag_jobid then
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
  tag_jobid = -1
end

function M.run(argv)
  if tag_jobid ~= -1 then
    nt.notify('previous tag command is not finished')
    return
  end

  nt.notify_max_width = vim.fn.float2nr(vim.o.columns * 0.3)

  stderr_data = {}

  local cmd = { 'git', 'tag' }

  if argv then
    for _, v in ipairs(argv) do
      table.insert(cmd, v)
    end
  end
  log.debug(vim.inspect(cmd))
  tag_jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })

  if tag_jobid == -1 then
    nt.notify('`git` is not executable', 'WarningMsg')
  end
end

local function get_all_tags()
  return vim.fn.systemlist('git tag')
end

function M.complete(ArgLead, CmdLine, CursorPos)
  local str = string.sub(CmdLine, 1, CursorPos)
  if vim.regex([[^Git\s\+tag\s\+-\+$]]):match_str(str) then
    return table.concat({'--list', '-l', '-m', '-a', '-d'}, '\n')
  elseif vim.regex([[^Git\s\+tag\s\+.*-d\s\+[^ -]*$]]):match_str(str) then
    return table.concat(get_all_tags(), '\n')
  else
    return ''
  end
end

return M


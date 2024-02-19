--=============================================================================
-- shortlog.lua --- Git shortlog command
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local jobid = -1
local plog_jobid = -1
nt.notify_max_width = vim.o.columns * 0.5
nt.timeout = 5000

local function on_stdout(id, data)
  if id ~= jobid then
    return
  end
  for _, v in ipairs(data) do
    nt.notify(v)
  end
end

local function on_stderr(id, data)
  if id ~= jobid then
    return
  end
  for _, v in ipairs(data) do
    nt.notify(v, 'WarningMsg')
  end
end

local function on_exit(id, code, single)
  log.debug('git-shortlog exit code:' .. code .. ' single:' .. single)
end

local pretty_log = {}

local function on_pretty_stdout(id, data)
  if id ~= plog_jobid then
    return
  end
  for _, v in ipairs(data) do
    table.insert(pretty_log, v)
  end
end

local function on_pretty_stderr(id, data)
  
end

local function on_pretty_exit(id, code, single)
  if id ~= plog_jobid then
    return
  end
  log.debug('git-shortlog plog exit code:' .. code .. ' single:' .. single)
  job.send(jobid, pretty_log)
  job.chanclose(jobid, 'stdin')
  job.stop(jobid)
end

function M.run(argv)
  local cmd = { 'git', 'shortlog' }
  for _, v in ipairs(argv) do
    table.insert(cmd, v)
  end
  log.debug('git-shortlog cmd:' .. vim.inspect(cmd))
  jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
  pretty_log = {}

  local plog_cmd = { 'git', 'log', '--pretty=short' }
  for _, v in ipairs(argv) do
    table.insert(plog_cmd, v)
  end
  log.debug('git-shortlog plog cmd:' .. vim.inspect(plog_cmd))
  plog_jobid = job.start(plog_cmd, {
    on_stdout = on_pretty_stdout,
    on_stderr = on_pretty_stderr,
    on_exit = on_pretty_exit
  })

end

return M


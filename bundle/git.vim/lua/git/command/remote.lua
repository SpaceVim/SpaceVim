--=============================================================================
-- remote.lua --- Git remote command
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
  log.debug('git-remote exit code:' .. code .. ' single:' .. single)
end

function M.run(argv)
  local cmd = { 'git', 'remote' }
  for _, v in ipairs(argv) do
    table.insert(cmd, v)
  end
  log.debug('git-remote cmd:' .. vim.inspect(cmd))
  jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
end

return M

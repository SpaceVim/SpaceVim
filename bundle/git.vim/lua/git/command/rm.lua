--=============================================================================
-- rm.lua --- Git rm command
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local m = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')
local stddata = {}

local function on_exit(id, code, single)
  log.debug('git-rm exit code:' .. code .. ' single:' .. single)
  if code == 0 and single == 0 then
    if vim.fn.exists(':GitGutter') == 2 then
      vim.cmd('GitGutter')
    end
    nt.notify('git rm done!')
  else
    nt.notify(table.concat(stddata, '\n'), 'warningmsg')
  end
end

local function on_std(id, data)
  for _, v in ipairs(data) do
    table.insert(stddata, v)
  end
end

function m.run(argv)
  local cmd = { 'git', 'rm' }
  if #argv == 1 and argv[1] == '%' then
    table.insert(cmd, vim.fn.expand('%'))
  else
    for _, v in ipairs(argv) do table.insert(cmd, v) end
  end
  log.debug('git-rm cmd:' .. vim.inspect(cmd))
  stddata = {}
  job.start(cmd, {
    on_exit = on_exit,
    on_stdout = on_std,
    on_stderr = on_std
  })
end

function M.complete(ArgLead, CmdLine, CursorPos)
  local rst = vim.fn.getcompletion(ArgLead, 'file')
  return table.concat(rst, '\n')
end

return m

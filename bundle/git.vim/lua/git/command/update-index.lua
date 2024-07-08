--=============================================================================
-- update-index --- Git update-index command
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
  log.debug('git-update-index exit code:' .. code .. ' single:' .. single)
  if code == 0 and single == 0 then
    if vim.fn.exists(':GitGutter') == 2 then
      vim.cmd('GitGutter')
    end
    nt.notify('git update index done!')
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
  local cmd = { 'git', 'update-index' }
  for _, v in ipairs(argv) do
    if v == '%' then
      table.insert(cmd, vim.fn.expand('%'))
    else
      table.insert(cmd, v)
    end
  end
  log.debug('git-update-index cmd:' .. vim.inspect(cmd))
  stddata = {}
  job.start(cmd, {
    on_exit = on_exit,
    on_stdout = on_std,
    on_stderr = on_std,
  })
end

return m

--=============================================================================
-- reset.lua --- Git reset command
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local function on_exit(id, code, single)
  log.debug('git-reset exit code:' .. code .. ' single:' .. single)
  if code == 0 and single == 0 then
    if vim.fn.exists(':GitGutter') == 2 then
      vim.cmd('GitGutter')
    end
    nt.notify('git reset done!')
  else
    nt.notify('git reset failed!')
  end
end

function M.run(argv)
  local cmd = { 'git', 'reset' }
  if #argv == 1 and argv[1] == '%' then
    cmd = { 'git', 'reset', 'HEAD', vim.fn.expand('%') }
  else
    for _, v in ipairs(argv) do
      table.insert(cmd, v)
    end
  end
  log.debug('git-reset cmd:' .. vim.inspect(cmd))
  job.start(cmd, {
    on_exit = on_exit,
  })
end

function M.complete(ArgLead, CmdLine, CursorPos)
  local rst = vim.fn.getcompletion(ArgLead, 'file')
  return table.concat(rst, '\n')
end

return M

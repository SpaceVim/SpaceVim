--=============================================================================
-- grep.lua --- git grep to quickfix
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')
local grep_stdout = {}
local grep_stderr = {}
local jobid = -1

local function on_exit(id, code, single)
  log.debug('git-rm exit code:' .. code .. ' single:' .. single)
  if id ~= jobid then
    return
  end
  if code == 0 and single == 0 then
    local rst = {}
    for _, d in ipairs(grep_stdout) do
      local info = vim.fn.split(d, [[\:\d\+\:]])
      if #info == 2 then
        local fname = info[1]
        local text = info[2]
        local lnum = string.sub(vim.fn.matchstr(d, [[\:\d\+\:]]), 2, -2)
        table.insert(rst, {
          filename = vim.fn.fnamemodify(fname, ':p'),
          lnum = lnum,
          text = text,
        })
      end
    end
    if #rst > 0 then
      vim.fn.setqflist({}, 'r', {
        title = 'Git grep results: ' .. #rst .. ' items',
        items = rst,
      })
      vim.cmd('botright copen')
    else
      nt.notify(':Git grep no results!')
    end
  else
    if #grep_stderr == 0 then
      nt.notify(':Git git no results', 'warningmsg')
    else
      nt.notify(grep_stderr[1], 'warningmsg')
      nt.notify('for more info, checkout SPC h L')
      for _, v in ipairs(grep_stderr) do
        log.debug(v)
      end
    end
  end
end

local function on_stdout(id, data)
  if id ~= jobid then
    return
  end
  for _, v in ipairs(data) do
    table.insert(grep_stdout, v)
  end
end
local function on_stderr(id, data)
  if id ~= jobid then
    return
  end
  for _, v in ipairs(data) do
    table.insert(grep_stderr, v)
  end
end
function M.run(argv)
  local cmd = { 'git', 'grep', '-n' }
  for _, v in ipairs(argv) do
    table.insert(cmd, v)
  end
  log.debug('git-grep cmd:' .. vim.inspect(cmd))
  grep_stdout = {}
  grep_stderr = {}
  jobid = job.start(cmd, {
    on_exit = on_exit,
    on_stdout = on_stdout,
    on_stderr = on_stderr,
  })
end

return M

--=============================================================================
-- reflog.lua --- git-reflog
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local reflog_stdout = {}
local reflog_stderr = {}
local jobid = -1
local reflog_bufid = -1

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')

local log = require('git.log')

local function on_stdout(id, data)
  if id ~= jobid then
    return
  end

  for _, v in ipairs(data) do
    table.insert(reflog_stdout, v)
  end
end

local function on_stderr(id, data)
  if id ~= jobid then
    return
  end

  for _, v in ipairs(data) do
    table.insert(reflog_stderr, v)
  end
end

local function open_reflog_buffer()
  local previous_buf = vim.api.nvim_get_current_buf()
  vim.cmd('edit git://reflog')
  vim.cmd([[
    normal! "_dd
    setl nobuflisted
    setl nomodifiable
    setl nonumber norelativenumber
    setl buftype=nofile
    setl bufhidden=wipe
    setf git-reflog
  ]])
  vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', 'q', '', {
    callback = function ()
      if vim.api.nvim_buf_is_valid(previous_buf) then
        vim.api.nvim_set_current_buf(previous_buf)
      else
        vim.cmd('bd')
      end
    end,
  })
  return vim.api.nvim_get_current_buf()
end

local function on_exit(id, code, signal)
  log.debug(string.format('git-reflog exit code %d, signal %d', code, signal))

  if code == 0 and signal == 0 then
    reflog_bufid = open_reflog_buffer()

    vim.api.nvim_buf_set_option(reflog_bufid, 'modifiable', true)
    vim.api.nvim_buf_set_lines(reflog_bufid, 0, -1, false, reflog_stdout)
    vim.api.nvim_buf_set_option(reflog_bufid, 'modifiable', false)
  else
    nt.notify(string.format('failed to run git reflog, exit code: %d', code), 'WaringMsg')
  end

  jobid = -1
end

function M.run(argv)
  local cmd = { 'git', 'reflog' }

  for _, v in ipairs(argv) do
    table.insert(cmd, v)
  end

  log.debug('git-reflog cmd:' .. vim.inspect(cmd))
  reflog_stdout = {}
  reflog_stderr = {}
  jobid = job.start(cmd, {
    on_stderr = on_stderr,
    on_stdout = on_stdout,
    on_exit = on_exit,
  })
end

return M

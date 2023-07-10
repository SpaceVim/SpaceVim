--=============================================================================
-- M.lua
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local runners = {}

local logger = require('spacevim.logger').derive('runner')
local job = require('spacevim.api').import('job')

local code_runner_bufnr = 0

local winid = -1

local target = ''

local runner_lines = 0

local runner_jobid = 0

local runner_status = {
  is_running = false,
  has_errors = false,
  exit_code = 0,
  exit_single = 0,
}

local task_status = {}

local task_stdout = {}

local task_stderr = {}

local task_problem_matcher = {}

local selected_language = ''

local function open_win()
  if
    code_runner_bufnr ~= 0
    and vim.api.nvim_buf_is_valid(code_runner_bufnr)
    and vim.fn.index(vim.fn.tabpagebuflist(), code_runner_bufnr) ~= -1
  then
    return
  end
  vim.cmd('botright split __runner__')
  local lines = vim.o.lines * 30 / 100
  vim.cmd('resize ' .. lines)
  vim.cmd([[
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable
  set filetype=SpaceVimRunner
  ]])
end

local function insert()
  vim.fn.inputsave()
  local input = vim.fn.input('input >')
  if vim.fn.empty(input) == 0 and runner_status.is_running then
    job.send(runner_jobid, input)
  end
  vim.cmd('normal! :')
  vim.fn.inputrestore()
end

local function stop_runner()
  if runner_status.is_running then
    job.stop(runner_jobid)
  end
end

local function update_statusline()
  vim.cmd('redrawstatus!')
end

function M.open(...)
  stop_runner()
  runner_jobid = 0
  runner_lines = 0
  runner_status = {
    is_running = false,
    has_errors = false,
    exit_code = 0,
    exit_single = 0,
  }
  local language = vim.o.filetype
  local runner = select(1, ...) or runners[language] or ''
  local opts = select(2, ...) or {}
  if vim.fn.empty(runner) == 0 then
    open_win()
    async_run(runner, opts)
    update_statusline()
  else
  end
end

return M

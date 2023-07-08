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

local function insert() -- {{{
  vim.fn.inputsave()
  local input = vim.fn.input('input >')
  if vim.fn.empty(input) == 0 and runner_status.is_running then
    job.send(runner_jobid, input)
  end
  vim.cmd('normal! :')
  vim.fn.inputrestore()
end
-- }}}

return M

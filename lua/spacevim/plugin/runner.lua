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
local file = require('spacevim.api').import('file')
local str = require('spacevim.api').import('data.string')

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

local selected_file = ''
--- @type any[]
local start_time
--- @type any[]
local end_time

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

local function extend(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
end
local function update_statusline()
  vim.cmd('redrawstatus!')
end

local function on_stdout(id, data, event)
  if id ~= runner_jobid then
    return
  end
  if vim.api.nvim_buf_is_valid(code_runner_bufnr) then
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(code_runner_bufnr, runner_lines, runner_lines + 1, false, data)
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', false)
    runner_lines = runner_lines + #data
    if winid >= 0 then
      vim.api.nvim_win_set_cursor(winid, { vim.api.nvim_buf_line_count(code_runner_bufnr), 1 })
    end
    update_statusline()
  end
end
local function on_stderr(id, data, event)
  if id ~= runner_jobid then
    return
  end
  runner_status.has_errors = true
  if vim.api.nvim_buf_is_valid(code_runner_bufnr) then
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(code_runner_bufnr, runner_lines, runner_lines + 1, false, data)
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', false)
    runner_lines = runner_lines + #data
    if winid >= 0 then
      vim.api.nvim_win_set_cursor(winid, { vim.api.nvim_buf_line_count(code_runner_bufnr), 1 })
    end
    update_statusline()
  end
end
local function on_exit(id, code, single)
  if id ~= runner_jobid then
    return
  end
  end_time = vim.fn.reltime(start_time)
  runner_status.is_running = false
  runner_status.exit_single = single
  runner_status.exit_code = code
  local done = {
    '',
    '[Done] exited with code=' .. code .. ', single=' .. single .. ' in ' .. str.trim(
      vim.fn.reltimestr(end_time)
    ) .. ' seconds',
  }
  if vim.api.nvim_buf_is_valid(code_runner_bufnr) then
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(code_runner_bufnr, runner_lines, runner_lines + 1, false, done)
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', false)
    if winid >= 0 then
      vim.api.nvim_win_set_cursor(winid, { vim.api.nvim_buf_line_count(code_runner_bufnr), 1 })
    end
    update_statusline()
  end
end

local function merged_array(...)
  local t = {}

  for _, tb in ipairs({ ... }) do
    for _, v in ipairs(tb) do
      table.insert(t, v)
    end
  end
  return t
end

local function on_compile_exit(id, code, single)
  if id ~= runner_jobid then
    return
  end
  if code == 0 and single == 0 then
    runner_jobid = job.start(target, {
      on_stdout = on_stdout,
      on_stderr = on_stderr,
      on_exit = on_exit,
    })
    if runner_jobid > 0 then
      runner_status = {
        is_running = true,
        has_errors = false,
        exit_code = 0,
        exit_single = 0,
      }
    end
  else
    end_time = vim.fn.reltime(start_time)
    runner_status.is_running = false
    runner_status.exit_code = code
    runner_status.exit_single = single
    local done = {
      '',
      '[Done] exited with code=' .. code .. ', single=' .. single .. ' in ' .. str.trim(
        vim.fn.reltimestr(end_time)
      ) .. ' seconds',
    }
    if vim.api.nvim_buf_is_valid(code_runner_bufnr) then
      vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', true)
      vim.api.nvim_buf_set_lines(code_runner_bufnr, runner_lines, runner_lines + 1, false, done)
      vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', false)
      if winid >= 0 then
        vim.api.nvim_win_set_cursor(winid, { vim.api.nvim_buf_line_count(code_runner_bufnr), 1 })
      end
      update_statusline()
    end
  end
end

local function async_run(runner, ...)
  if type(runner) == 'string' then
    local cmd = runner
    pcall(function()
      local f
      if selected_file ~= '' then
        f = selected_file
      else
        f = vim.fn.bufname('%')
      end
      cmd = vim.fn.printf(runner, f)
    end)
    logger.info('   cmd:' .. cmd)
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(
      code_runner_bufnr,
      runner_lines,
      -1,
      false,
      { '[Running] ' .. cmd, '', vim.fn['repeat']('-', 20) }
    )
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', false)
    runner_lines = runner_lines + 3
    start_time = vim.fn.reltime()
    local opts = select(1, ...) or {}
    extend(opts, {
      on_stdout = on_stdout,
      on_stderr = on_stderr,
      on_exit = on_exit,
    })
    runner_jobid = job.start(cmd, opts)
  elseif type(runner) == 'table' and #runner == 2 then
    target = file.unify_path(vim.fn.tempname(), ':p')
    local dir = vim.fn.fnamemodify(target, ':h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
    local compile_cmd
    local usestdin
    local compile_cmd_info
    if type(runner[1]) == 'table' then
      local exe
      if type(runner[1].exe) == 'function' then
        exe = runner[1].exe()
      elseif type(runner[1].exe) == 'string' then
        exe = { runner[1].exe }
      end
      usestdin = runner[1].usestdin or false
      compile_cmd = merge_list(exe, { runner[1].targetopt or '' }, { target }, runner[1].opt)
      if not usestdin then
        local f
        if selected_file == '' then
          f = vim.fn.bufname('%')
        else
          f = selected_file
        end
        compile_cmd = merge_list(compile_cmd, { f })
      end
    elseif type(runner[1]) == 'string' then
    end

    if type(compile_cmd) == 'table' then
      if usestdin then
        compile_cmd_info = tostring(merge_list(compile_cmd, { 'STDIN' }))
      else
        compile_cmd_info = tostring(compile_cmd)
      end
    else
      if usestdin then
        compile_cmd_info = compile_cmd .. ' STDIN'
      else
        compile_cmd_info = compile_cmd
      end
    end

    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(
      code_runner_bufnr,
      runner_lines,
      -1,
      false,
      { '[Compile] ' .. compile_cmd_info, '[Running]' .. target, '', vim.fn['repeat']('-', 20) }
    )
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', false)

    runner_lines = runner_lines + 4
    start_time = vim.fn.reltime()
    if
      type(compile_cmd) == 'string'
      or type(compile_cmd) == 'table' and vim.fn.executable(compile_cmd[1] or '') == 1
    then
      runner_jobid = job.start(compile_cmd, {
        on_stdout = on_stdout,
        on_stderr = on_stderr,
        on_exit = on_compile_exit,
      })
      if usestdin and runner_jobid > 0 then
        local range = runner[1].range or { 1, '$' }
        job.send(runner_jobid, vim.fn.getline(unpack(range)))
        job.chanclose(runner_jobid, 'stdin')
      end
    else
      local exe = compile_cmd[1] or ''
      vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', true)
      vim.api.nvim_buf_set_lines(
        code_runner_bufnr,
        runner_lines,
        -1,
        false,
        { exe .. ' is not executable, make sure ' .. exe .. ' is in your PATH' }
      )
      vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', false)
    end
  end

  if runner_jobid > 0 then
    runner_status = {
      is_running = true,
      has_errors = false,
      exit_code = 0,
      exit_single = 0,
    }
  end
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

function M.reg_runner(ft, runner)
  runners[ft] = runner
end

return M

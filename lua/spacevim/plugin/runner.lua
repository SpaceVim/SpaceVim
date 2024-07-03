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
local nt = require('spacevim.api.notify')

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

local function stop_runner()
  if runner_status.is_running then
    logger.debug('stop runner:' .. runner_jobid)
    job.stop(runner_jobid)
  end
end

-- tbl_extend should provide default behavior

local function tbl_extend(t1, t2)
  return vim.tbl_extend('force', t1, t2)
end

local function close_win()
  stop_runner()
  if code_runner_bufnr ~= 0 and vim.api.nvim_buf_is_valid(code_runner_bufnr) then
    vim.cmd('bd ' .. code_runner_bufnr)
  end
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

local function open_win()
  if
    code_runner_bufnr ~= 0
    and vim.api.nvim_buf_is_valid(code_runner_bufnr)
    and vim.fn.index(vim.fn.tabpagebuflist(), code_runner_bufnr) ~= -1
  then
    return
  end
  logger.debug('open code runner windows')
  local previous_wind = vim.api.nvim_get_current_win()
  vim.cmd('botright split __runner__')
  code_runner_bufnr = vim.fn.bufnr('%')
  local lines = vim.o.lines * 30 / 100
  vim.cmd('resize ' .. lines)
  vim.cmd([[
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable
  set filetype=SpaceVimRunner
  ]])
  vim.api.nvim_buf_set_keymap(code_runner_bufnr, 'n', 'q', '', {
    callback = close_win,
  })
  vim.api.nvim_buf_set_keymap(code_runner_bufnr, 'n', 'i', '', {
    callback = insert,
  })
  vim.api.nvim_buf_set_keymap(code_runner_bufnr, 'n', '<C-c>', '', {
    callback = stop_runner,
  })
  local id = vim.api.nvim_create_augroup('spacevim_runner', {
    clear = true,
  })
  vim.api.nvim_create_autocmd({ 'BufWipeout' }, {
    group = id,
    buffer = code_runner_bufnr,
    callback = stop_runner,
  })
  winid = vim.api.nvim_get_current_win()
  if vim.g.spacevim_code_runner_focus == 0 then
    vim.api.nvim_set_current_win(previous_wind)
  end
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

local function merge_list(...)
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
        compile_cmd_info = vim.inspect(merge_list(compile_cmd, { 'STDIN' }))
      else
        compile_cmd_info = vim.inspect(compile_cmd)
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
      { '[Compile] ' .. compile_cmd_info, '[Running] ' .. target, '', vim.fn['repeat']('-', 20) }
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
        job.stop(runner_jobid)
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
  elseif type(runner) == 'table' then
    local cmd = {}
    if type(runner.exe) == 'function' then
      cmd = merge_list(cmd, runner.exe())
    elseif type(runner.exe) == 'string' then
      cmd = { runner.exe }
    end
    local usestdin = runner.usestdin or false
    cmd = merge_list(cmd, runner.opt)
    if not usestdin then
      if selected_file == '' then
        cmd = merge_list(cmd, vim.fn.bufname('%'))
      else
        cmd = merge_list(cmd, selected_file)
      end
    end
    logger.info('   cmd:' .. vim.inspect(cmd))
    local running_command = table.concat(cmd, ' ')
    if usestdin then
      running_command = running_command .. ' STDIN'
    end
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(
      code_runner_bufnr,
      runner_lines,
      -1,
      false,
      { '[Running] ' .. running_command, '', vim.fn['repeat']('-', 20) }
    )
    vim.api.nvim_buf_set_option(code_runner_bufnr, 'modifiable', false)
    runner_lines = runner_lines + 3
    start_time = vim.fn.reltime()
    if vim.fn.empty(cmd) == 0 and vim.fn.executable(cmd[1]) == 1 then
      runner_jobid = job.start(cmd, {
        on_stdout = on_stdout,
        on_stderr = on_stderr,
        on_exit = on_exit,
      })
      if usestdin and runner_jobid > 0 then
        local range = runner.range or { 1, '$' }
        -- if selected file is not empty
        -- read the context from selected file.
        local text
        if selected_file == '' then
          text = vim.fn.getline(unpack(range))
        else
          text = vim.fn.readfile(selected_file, '')
        end
        job.send(runner_jobid, text)
        job.chanclose(runner_jobid, 'stdin')
        job.stop(runner_jobid)
      end
    else
      local exe = cmd[1] or ''
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
  logger.debug('runner is:\n' .. vim.inspect(runner))
  logger.debug('opt is:\n' .. vim.inspect(opts))
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

function M.status()
  local running_nr = 0
  local running_done = 0
  for _, v in ipairs(task_status) do
    if v.is_running then
      running_nr = running_nr + 1
    else
      running_done = running_done + 1
    end
  end

  if runner_status.is_running then
    running_nr = running_nr + 1
  end
  return string.format(' %s running, %s done', running_nr, running_done)
end

function M.close()
  close_win()
end

function M.select_file()
  runner_lines = 0
  runner_status = {
    is_running = false,
    has_errors = false,
    exit_code = 0,
    exit_single = 0,
  }

  if vim.loop.os_uname().sysname == 'Windows_NT' then
    -- what the fuck, why need trim?
    -- because powershell comamnd output has `\n` at the end, and filetype detection failed.
    selected_file = str.trim(vim.fn.system({
      'powershell',
      "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.OpenFileDialog;$f.Filter='Model Files All files (*.*)|*.*';$f.showHelp=$true;$f.ShowDialog()|Out-Null;$f.FileName",
    }))
  end

  if selected_file == '' then
    logger.debug('file to get selected filename!')
    return
  else
    logger.debug('selected file is:' .. selected_file)
    local ft = vim.filetype.match({ filename = selected_file })
    if not ft then
      logger.debug('failed to detect filetype of selected file:' .. selected_file)
      return
    end
    local runner = runners[ft]
    logger.info(vim.inspect(runner))
    if runner then
      open_win()
      async_run(runner)
      update_statusline()
    end
  end
end

function M.select_language() end

function M.get(ft)
  return runners[ft] or ''
end

local function match_problems(output, matcher)
  if matcher.pattern then
    local pattern = matcher.pattern
    local items = {}
    for _, line in ipairs(output) do
      local rst = vim.fn.matchlist(line, pattern.regexp)
      local f_idx = 2
      if pattern.file then
        f_idx = pattern.file + 1
      end
      local f = rst[f_idx] or ''
      local l_idx = 3
      if pattern.line then
        l_idx = pattern.line + 1
      end
      local l = rst[l_idx] or 1
      local c_idx = 4
      if pattern.column then
        c_idx = pattern.column + 1
      end
      local column = rst[c_idx] or 1
      local m_idx = 5
      if pattern.message then
        m_idx = pattern.message + 1
      end
      local message = rst[m_idx] or ''
      if #f > 0 then
        table.insert(items, {
          filename = f,
          lnum = l,
          col = column,
          text = message,
        })
      end
    end
    vim.fn.setqflist({}, 'r', { title = ' task output', items = items })
    vim.cmd('copen')
  else
    local olderrformat = vim.o.errorformat
    pcall(function()
      vim.o.errorformat = matcher.errorformat
      vim.g._spacevim_task_output = output
      vim.cmd('noautocmd cexpr g:_spacevim_task_output')
      vim.fn.setqflist({}, 'a', { title = ' task output' })
      vim.cmd('copen')
      vim.g._spacevim_task_output = nil
    end)
    vim.o.errorformat = olderrformat
  end
end

local function on_backgroud_stdout(id, data, event)
  local d = task_stdout['task' .. id] or {}

  for _, v in ipairs(data) do
    table.insert(d, v)
  end

  task_stdout['task' .. id] = d
end

local function on_backgroud_stderr(id, data, event)
  local d = task_stderr['task' .. id] or {}

  for _, v in ipairs(data) do
    table.insert(d, v)
  end

  task_stderr['task' .. id] = d
end

local function on_backgroud_exit(id, code, single)
  local status = task_status['task' .. id]
    or {
      is_running = false,
      has_errors = false,
      start_time = 0,
      exit_code = 0,
    }
  end_time = vim.fn.reltime(status.start_time)
  status.is_running = false
  local problem_matcher = task_problem_matcher['task' .. id] or {}
  local output
  if problem_matcher.useStdout then
    output = task_stdout['task' .. id] or {}
  else
    output = task_stderr['task' .. id] or {}
  end
  if not vim.tbl_isempty(problem_matcher) and not vim.tbl_isempty(output) then
    match_problems(output, problem_matcher)
  end
  nt.notify(
    'task finished with code='
      .. code
      .. ' in '
      .. str.trim(vim.fn.reltimestr(end_time))
      .. ' seconds'
  )
end

local function run_backgroud(cmd, ...)
  local running_nr = 0
  local running_done = 0
  local opts = select(1, ...) or {}
  start_time = vim.fn.reltime()
  local problemMatcher = select(2, ...) or {}
  if not problemMatcher.errorformat and not problemMatcher.regexp then
    problemMatcher = tbl_extend(problemMatcher, { errorformat = vim.o.errorformat })
  end
  opts.on_stdout = on_backgroud_stdout
  opts.on_stderr = on_backgroud_stderr
  opts.on_exit = on_backgroud_exit
  local task_id = job.start(cmd, opts)
  task_problem_matcher = tbl_extend(task_problem_matcher, { ['task' .. task_id] = problemMatcher })
  logger.debug('task_problem_matcher is:\n' .. vim.inspect(task_problem_matcher))
  task_status = tbl_extend(task_status, {
    ['task' .. task_id] = {
      is_running = true,
      has_errors = false,
      start_time = start_time,
      exit_code = 0,
    },
  })
  for _, v in pairs(task_status) do
    if v.is_running then
      running_nr = running_nr + 1
    else
      running_done = running_done + 1
    end
  end
  nt.notify(string.format('tasks: %s running, %s done', running_nr, running_done))
end

function M.run_task(task)
  local isBackground = task.isBackground or false
  if not vim.tbl_isempty(task) then
    local cmd = task.command or ''
    local args = task.args or {}
    local opts = task.options or {}
    if #args > 0 and #cmd > 0 then
      cmd = cmd .. ' ' .. table.concat(args, ' ')
    end
    local opt = {}
    if opts.cwd then
      opt.cwd = opts.cwd
    end
    if opts.env then
      opt = tbl_extend(opt, { env = opts.env })
    end
    local problemMatcher = task.problemMatcher or {}
    if isBackground then
      run_backgroud(cmd, opt, problemMatcher)
    else
      M.open(cmd, opt, problemMatcher)
    end
  end
end

return M

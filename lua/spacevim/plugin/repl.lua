--=============================================================================
-- repl.lua --- REPL for spacevim
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local vopt = require('spacevim.api.vim.option')
local str = require('spacevim.api.data.string')
local spi = require('spacevim.api.unicode.spinners')

local log = require('spacevim.logger').derive('repl')

local lines = 0
local bufnr = -1
local winid = -1
local status = {}
local start_time
local end_time
local job_id = 0
local exes = {}
local repl_spinners = ''

local M = {}

local function close()
  if job_id > 0 then
    job.stop(job_id)
    job_id = 0
  end
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.cmd('bd ' .. bufnr)
  end
end

local function insert()
  vim.fn.inputsave()
  local input = vim.fn.input('input >')
  if vim.fn.empty(input) == 0 then
    if job_id == 0 then
      nt.notify('please restart the REPL', 'WarningMsg')
    else
      job.send(job_id, input)
    end
  end
  vim.api.nvim_echo({}, false, {})
  vim.fn.inputrestore()
end

local function close_repl()
  if job_id > 0 then
    job.stop(job_id)
    job_id = 0
  end
end

local function open_windows()
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.cmd('bd ' .. bufnr)
  end
  local previous_win = vim.api.nvim_get_current_win()
  vim.cmd('botright split __REPL__')
  bufnr = vim.api.nvim_get_current_buf()
  winid = vim.api.nvim_get_current_win()
  local l = math.floor(vim.o.lines * 30 / 100)
  vim.cmd('resize ' .. l)
  vim.api.nvim_set_current_win(previous_win)
  vopt.setlocalopt(bufnr, winid, {
    buftype = 'nofile',
    bufhidden = 'wipe',
    buflisted = false,
    list = false,
    swapfile = false,
    wrap = false,
    cursorline = true,
    spell = false,
    number = false,
    relativenumber = false,
    winfixheight = true,
    modifiable = false,
    filetype = 'SpaceVimREPL',
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '', {
    callback = close,
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'i', '', {
    callback = insert,
  })
  local id = vim.api.nvim_create_augroup('spacevim_repl', {
    clear = true,
  })
  vim.api.nvim_create_autocmd({ 'BufWipeout' }, {
    group = id,
    buffer = bufnr,
    callback = close_repl,
  })
end

local function on_stdout(_, data)
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(bufnr, lines, lines + 1, false, data)
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
    lines = lines + #data
    local cursor = vim.api.nvim_win_get_cursor(winid)
    if cursor[1] == vim.api.nvim_buf_line_count(bufnr) - #data then
      vim.api.nvim_win_set_cursor(winid, { vim.api.nvim_buf_line_count(bufnr), 0 })
    end
  end
end

local function on_stderr(_, data)
  status.has_errors = true
  on_stdout(_, data)
end

local function on_exit(id, code, single)
  end_time = vim.fn.reltime(start_time)
  status.is_exit = true
  status.is_running = false
  status.exit_code = code
  local done = {
    '',
    '[Done] exited with code='
      .. code
      .. ' in '
      .. str.trim(vim.fn.reltimestr(end_time))
      .. ' seconds',
  }
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(bufnr, lines, lines + 1, false, done)
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  end
  job_id = 0
  spi.stop()
end

local function start(exe)
  lines = 0
  status = {
    is_running = true,
    is_exit = false,
    has_errors = false,
    exit_code = 0,
  }

  start_time = vim.fn.reltime()
  open_windows()
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
  vim.api.nvim_buf_set_lines(
    bufnr,
    lines,
    lines + 3,
    false,
    { '[REPL executable] ' .. vim.fn.string(exe), '', string.rep('-', 20) }
  )
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  vim.api.nvim_win_set_cursor(winid, { vim.api.nvim_buf_line_count(bufnr), 0 })
  lines = lines + 3
  job_id = job.start(exe, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
  if job_id > 0 then
    spi.apply('dot1', function(v)
      repl_spinners = v
      if vim.api.nvim_win_is_valid(winid) then
        vim.fn.win_execute(winid, 'redrawstatus')
      end
    end)
  end
end

function M.start(ft)
  log.info('start repl for filetype:' .. ft)
  local exe = exes[ft] or ''
  log.debug('get the command:' .. vim.inspect(exe))
  if exe ~= '' then
    start(exe)
  else
    vim.api.nvim_echo({ { 'no REPL executable for ' .. ft, 'WarningMsg' } }, false, {})
  end
end

function M.send(t, ...)
  if job_id == 0 then
    nt.notify('please restart the REPL', 'WarningMsg')
  else
    if t == 'line' then
      job.send(job_id, { vim.api.nvim_get_current_line(), '' })
    elseif t == 'buffer' then
      local data = vim.fn.getline(1, '$')
      table.insert(data, '')
      job.send(job_id, data)
    elseif t == 'raw' then
      local context = select(1, ...)
      if type(context) == 'string' then
        job.send(job_id, context)
      end
    elseif t == 'selection' then
      local b = vim.fn.getpos("'<")
      local e = vim.fn.getpos("'>")
      if b[2] ~= 0 and e[2] ~= 0 then
        local data = vim.fn.getline(b[2], e[2])
        table.insert(data, '')
        job.send(job_id, data)
      else
        nt.notify('no selection text', 'WarningMsg')
      end
    end
  end
end

function M.reg(ft, execute)
  exes[ft] = execute
end

function M.status()
  if status.is_running then
    return 'running ' .. repl_spinners
  elseif status.is_exit then
    return 'exit code:' .. status.exit_code .. '   time:' .. str.trim(vim.fn.reltimestr(end_time))
  end
end

return M

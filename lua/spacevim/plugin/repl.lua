--=============================================================================
-- repl.lua --- REPL for spacevim
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local job = require('spacevim.api.job')
local vopt = require('spacevim.api.vim.option')

local log = require('spacevim.logger').derive('repl')

local lines = 0
local bufnr = -1
local winid = -1
local status = {}
local start_time
local job_id = 0
local exes = {}

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
  if vim.fn.empty(input) == 0 and status.is_running then
    job.send(job_id, input)
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
  vim.cmd('botright split __REPL__')
  bufnr = vim.api.nvim_get_current_buf()
  winid = vim.api.nvim_get_current_win()
  local l = math.floor(vim.o.lines * 30 / 100)
  vim.cmd('resize ' .. l)
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
    vim.api.nvim_buf_set_lines(bufnr, lines, lines + 1, false, data)
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
  vim.api.nvim_buf_set_lines(
    bufnr,
    lines,
    lines + 3,
    false,
    { '[REPL executable] ' .. vim.fn.string(exe), '', string.rep('-', 20) }
  )
  vim.api.nvim_win_set_cursor(winid, { vim.api.nvim_buf_line_count(bufnr), 0 })
  lines = lines + 3
  job_id = job.start(exe, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
end

function M.start(ft)
  log.info('start repl for filetype:' .. ft)
  local exe = exes[ft] or ''
  log.debug('get the command:' .. exe)
  if exe ~= '' then
    start(exe)
  else
    vim.api.nvim_echo({{'no REPL executable for ' .. ft, 'WarningMsg'}}, false, {})
  end

end
  

return M

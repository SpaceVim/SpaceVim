--=============================================================================
-- todo.lua --- todo manager for SpaceVim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local sys = require('spacevim.api').import('system')
local reg = require('spacevim.api').import('vim.regex')

local bufnr = -1
local todo_jobid = -1
local todos = {}
local todo = {}
local winnr = -1
-- set the default labels for todo manager.
local labels = { 'fixme', 'question', 'todo', 'idea' }
local prefix = '@'

local grep_default_exe, grep_default_opt, grep_default_ropt, grep_default_expr_opt, grep_default_fix_string_opt, grep_default_ignore_case, grep_default_smart_case =
  require('spacevim.plugin.search').default_tool()

local logger = require('spacevim.logger').derive('todo')

local jobstart = vim.fn.jobstart

-- the labels_partten is used for viml function: matchstr etc
local labels_partten = ''
-- labels_regex is for command line argv
local labels_regex = ''

local function empty(d) -- {{{
  if type(d) == 'string' then
    return d == ''
  end
end
-- }}}

local function stderr(id, data, event) -- {{{
  if id ~= todo_jobid then
    return
  end
  for _, d in ipairs(data) do
    logger.debug('stderr: ' .. d)
  end
end
-- }}}

local function data_to_todo(d) -- {{{
  logger.debug('stdout:' .. d)
  local f = vim.split(d, ':%d+:')[1]
  logger.debug('file is:' .. f)
  local i, j = string.find(d, ':%d+:')
  local line = string.sub(d, i + 1, j - 1)
  logger.debug('line is:' .. line)
  local column = string.sub(vim.fn.matchstr(d, [[\(:\d\+\)\@<=:\d\+:]]), 1, -2)
  local label = string.sub(vim.fn.matchstr(d, labels_partten), #prefix + 1, -1)
  logger.debug('label is:' .. label)
  local title = vim.fn.get(vim.fn.split(d, prefix .. label), 1, '')
  logger.debug('title is:' .. title)
  return {
    file = f,
    line = line,
    column = column,
    title = title,
    label = label,
  }
end
-- }}}

local function stdout(id, data, event) -- {{{
  if id ~= todo_jobid then
    return
  end
  for _, d in ipairs(data) do
    if not empty(d) then
      table.insert(todos, data_to_todo(d))
    end
  end
end
-- }}}
local function open_todo() -- {{{
  local t = todos[vim.fn.line('.')]
  vim.cmd('close')
  vim.cmd(winnr .. 'wincmd w')
  vim.cmd('e ' .. t.file)
  vim.fn.cursor(t.line, t.column)
  vim.cmd('noautocmd normal! :')
end
-- }}}
--
local function apply_to_quickfix() -- {{{
  local qf = {}
  for _, v in ipairs(todos) do
    table.insert(qf, {
      filename = v.file,
      lnum = v.line,
      col = v.column,
      text = v.title,
      type = v.label,
    })
  end
  vim.fn.setqflist({}, 'r', {
    title = 'Todos',
    items = qf,
  })
  vim.cmd('close')
  vim.cmd(winnr .. 'wincmd w')
  vim.cmd('botright copen')
end
-- }}}

local function indexof(t, v) -- {{{
  for i, x in ipairs(t) do
    if x == v then
      return i
    end
  end
  return -1
end
-- }}}

local function extend(t1, t2) -- {{{
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end
-- }}}
local function compare_todo(a, b) -- {{{
  local i = indexof(labels, a.label)
  local j = indexof(labels, b.label)
  if i < j then
    return true
  else
    return false
  end
end
-- }}}

local function max_len(t, k) -- {{{
  local l = 0
  for _, v in ipairs(t) do
    l = math.max(#v[k], l)
  end
  return l
end
-- }}}

local function on_exit(id, data, event) -- {{{
  if id ~= todo_jobid then
    return
  end
  logger.info('todomanager job exit with:' .. data)
  table.sort(todos, compare_todo)
  local lw = max_len(todos, 'label') + 1
  local fw = max_len(todos, 'file') + 1
  local lines = {}
  for _, v in ipairs(todos) do
    table.insert(
      lines,
      prefix
        .. v.label
        .. string.rep(' ', lw - #v.label)
        .. v.file
        .. string.rep(' ', fw - #v.file)
        .. v.title
    )
  end
  local ma = vim.fn.getbufvar(bufnr, '&ma')
  vim.fn.setbufvar(bufnr, '&ma', 1)
  -- update the buffer only when the buffer exists.
  if vim.fn.bufexists(bufnr) == 1 then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end
  vim.fn.setbufvar(bufnr, '&ma', ma)
end
-- }}}

-- labels to command line regex
local function get_labels_regex() -- {{{
  local sep = ''
  if grep_default_exe == 'rg' then
    sep = '|'
  elseif grep_default_exe == 'grep' then
    sep = '\\|'
  else
    sep = '|'
  end
  local rst = ''
  local i = 1
  for _, v in ipairs(labels) do
    rst = rst .. prefix .. v .. [[\b]]
    if i ~= #labels then
      rst = rst .. sep
    end
    i = i + 1
  end
  return rst
end
-- }}}

local function get_labels_partten() -- {{{
  local sep = '|'
  local rst = [[\v]]
  local i = 1
  local p = prefix
  if prefix == '@' then
    p = [[\@]]
  end
  for _, v in ipairs(labels) do
    rst = rst .. p .. v .. [[>]]
    if i ~= #labels then
      rst = rst .. sep
    end
    i = i + 1
  end
  return rst
end
-- }}}

local function update_todo_content() -- {{{
  if vim.g.spacevim_todo_labels ~= nil then
    labels = vim.g.spacevim_todo_labels
  end
  if vim.g.spacevim_todo_prefix ~= nil then
    prefix = vim.g.spacevim_todo_prefix
  end
  todos = {}
  labels_regex = get_labels_regex()
  labels_partten = get_labels_partten()
  local argv = { grep_default_exe }
  extend(argv, grep_default_opt)
  extend(argv, { labels_regex })
  if
    sys.isWindows
    and (grep_default_exe == 'rg' or grep_default_exe == 'ag' or grep_default_exe == 'pt')
  then
    extend(argv, { '.' })
  elseif sys.isWindows and grep_default_exe == 'findstr' then
    extend(argv, { '*.*' })
  elseif not sys.isWindows and grep_default_exe == 'rg' then
    extend(argv, { '.' })
  end
  extend(argv, grep_default_ropt)
  logger.info('cmd:' .. vim.inspect(argv))
  logger.info('   labels_partten: ' .. labels_partten)
  todo_jobid = jobstart(argv, {
    on_stdout = stdout,
    on_stderr = stderr,
    on_exit = on_exit,
  })
  logger.info('jobid:' .. todo_jobid)
end
-- }}}

local function open_win() -- {{{
  if bufnr ~= 0 and vim.fn.bufexists(bufnr) == 1 then
    vim.cmd('bd ' .. bufnr)
  end
  vim.cmd('botright split __todo_manager__')
  winnr = vim.fn.winnr('#')
  local lines = vim.o.lines * 30 / 100
  vim.cmd('resize ' .. lines)
  vim.cmd([[
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable
  set filetype=SpaceVimTodoManager
  ]])
  bufnr = vim.fn.bufnr('%')
  update_todo_content()
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Enter>', '', {
    callback = open_todo,
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-q>', '', {
    callback = apply_to_quickfix,
  })
end
-- }}}

function M.list() -- {{{
  open_win()
end
-- }}}

return M

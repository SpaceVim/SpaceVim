--=============================================================================
-- todo.lua --- todo manager for SpaceVim
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local sys = require('spacevim.api').import('system')

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

local function stderr(id, data, event) -- {{{
  if id ~= todo_jobid then
    return
  end
  for _, d in ipairs(data) do
    logger.info('stderr: ' .. d)
  end
end
-- }}}
local function stdout(id, data, event) -- {{{
  if id ~= todo_jobid then
    return
  end
  for _, d in ipairs(data) do
    logger.info('stdout:' .. d)
    if not empty(d) then
      local f = vim.split(d, ':%d+:')[1]
      local i, j = string.find(d, ':%d+:')
      local line = string.sub(d, i + 1, j - 1)
      local column = string.sub(vim.fn.matchstr(d, [[\(:\d\+\)\@<=:\d\+:]]), 1, -2)
      local label = vim.fn.matchstr(d, labels_partten)
      local title = vim.fn.get(vim.fn.split(d, label), 1, '')
      table.insert(todos, {
        fille = f,
        line = line,
        column = column,
        title = title,
        label = label,
      })
    end
  end
end
-- }}}
local function open_todo() -- {{{
  local t = todos[vim.fn.line('.')]
  close_todo_win()
  vim.cmd('e ' .. t.file)
  vim.fn.cursor(t.line, t.column)
  vim.cmd('noautocmd! normal! :')
end
-- }}}

local function indexof(t, v) -- {{{
  for i, x in ipairs(t) do
    if x == v then
      return i
    end
    return -1
  end
end
-- }}}

local function extend(t1, t2) -- {{{
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end
-- }}}

local function compare_todo(a, b) -- {{{
  local i = indexof(labels, a)
  local j = indexof(labels, b)
  if i < j then
    return true
  else
    return false
  end
end
-- }}}

function exit(id, data, event) -- {{{
  if id ~= todo_jobid then
    return
  end
  logger.info('todomanager job exit with:' .. data)
  todos = table.sort(todos, compare_todo)
end
-- }}}

local function get_labels_regex() -- {{{
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
  local labels_regex = get_labels_regex()
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
  logger.info('cmd:' .. tostring(argv))
  logger.info('   labels_partten: ' .. labels_partten)
  todo_jobid = jobstart(argv, {
    on_stdout = stdout,
    on_stderr = stderr,
    on_exit = exit,
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
end
-- }}}

function M.list() -- {{{
  open_win()
end
-- }}}

return M

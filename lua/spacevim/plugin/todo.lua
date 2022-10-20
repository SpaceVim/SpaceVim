--=============================================================================
-- todo.lua --- todo manager for SpaceVim
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local bufnr = -1
local todo_jobid = -1
local todos = {}
local winnr = -1
-- set the default labels for todo manager.
local labels = { 'fixme', 'question', 'todo', 'idea' }

local logger = require('spacevim.logger').derive('todo')

local function stderr(id, data, event) -- {{{
  if id ~= todo_jobid then
    return
  end
  for _, d in ipairs(data) do
    logger.info('stderr: ' .. d)
  end
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

local function update_todo_content() -- {{{
end
-- }}}

local function open_win() -- {{{
  if bufnr ~= 0 and vim.fn.bufexists(bufnr) then
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

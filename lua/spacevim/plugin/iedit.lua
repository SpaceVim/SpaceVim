--=============================================================================
-- iedit.lua --- multiple cursor for spacevim in lua
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local index = -1
local cursor_col = -1
local mode = ''
local hi_id = ''
local Operator = ''
local iedit_cursor_hi_info = {}

local hi = require('spacevim.api').import('vim.highlight')
local str = require('spacevim.api').import('data.string')
local cmp = require('spacevim.api').import('vim.compatible')
local v = require('spacevim.api').import('vim')

local logger = require('spacevim.logger').derive('iedit')

local cursor_stack = {}

local iedit_hi_info = {
  {
    name = 'IeditPurpleBold',
    guibg = '#3c3836',
    guifg = '#d3869b',
    ctermbg = '',
    ctermfg = 175,
    bold = 1,
  },{
    name = 'IeditBlueBold',
    guibg = '#3c3836',
    guifg = '#83a598',
    ctermbg = '',
    ctermfg = 109,
    bold = 1,
  },{
    name = 'IeditInactive',
    guibg = '#3c3836',
    guifg = '#abb2bf',
    ctermbg = '',
    ctermfg = 145,
    bold = 1,
  },
}


local function fixstack(idxs)
  local change = 0
  for _, i in vim.fn.range(1, #idxs) do
    cursor_stack[idxs[i][1]].col = cursor_stack[idxs[i][1]].col + change
    change  = change + idxs[i][2] - cursor_stack[idxs[i][1]].len
    cursor_stack[idxs[i][1]].len = idxs[i][0]
  end
end

local function reset_Operator(...)
  Operator = ''
end

local function timeout()
  timer_start(1000, reset_Operator)
end

local function highlight_cursor()
  hi.hi(iedit_cursor_hi_info)
  for _,i in vim.fn.range(1, #cursor_stack) do
    if cursor_stack[i].active then
      if i == index then
        vim.fn.matchaddpos('IeditPurpleBold',{
          {
            cursor_stack[i].lnum,
            cursor_stack[i].col,
            cursor_stack[i].len,
          }
        })
      else
        vim.fn.matchaddpos('IeditBlueBold',{
          {
            cursor_stack[i].lnum,
            cursor_stack[i].col,
            cursor_stack[i].len,
          }
        })
      end
      vim.fn.matchadd('SpaceVimGuideCursor', [[\%]]
      .. cursor_stack[i].lnum
      .. [[l\%]]
      .. (cursor_stack[i].col + vim.fn.len(cursor_stack[i].begin))
      .. 'c',
      99999)
    else
      vim.fn.matchaddpos('IeditInactive',{
        {
          cursor_stack[i].lnum,
          cursor_stack[i].col,
          cursor_stack[i].len,
        }
      })
    end
  end
end

local function remove_cursor_highlight()
  vim.fn.clearmatches()
end

local function handle_normal(char)
  
end

local function handle_insert(char)
  
end

local function parse_symbol(_begin, _end, symbol, use_expr, selectall)
  local len = #symbol
  local cursor = {vim.fn.line('.'), vim.fn.col('.')}
  for _, l in vim.fn.range(_begin, _end) do
    local line = vim.fn.getline(l)
    local idx = str.strAllIndex(line, symbol, use_expr)
    for pos_a, pos_b in idx do
      table.insert(cursor_stack, {
        cursor_begin = string.sub(line, pos_a, pos_b - 2),
        cursor_char = string.sub(line, pos_b - 1, pos_b - 1),
        cursor_end = '',
        active = selectall,
        lnum = l,
        col = pos_a + 1,
        len = pos_b - pos_a
      })
    end
  end
end

local function handle_f_char(char)
  remove_cursor_highlight()
  if char >= 32 and char <= 126 then
    Operator = ''
    for _, i in vim.fn.range(1, #cursor_stack) do
      local matchedstr = vim.fn.matchstr(cursor_stack[i].cursor_end, vim.fn.printf('[^%s]', vim.fn.nr2char(char)))
      cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin .. cursor_stack[i].cursor_char .. matchedstr
      cursor_stack[i].cursor_end   = vim.fn.matchstr(cursor_stack[i].cursor_end, vim.fn.printf([[[%s]\zs.*]], vim.fn.nr2char(char)))
      cursor_stack[i].cursor_char  = vim.fn.nr2char(char)
    end
  end
  highlight_cursor()
  return cursor_stack[1].cursor_begin
  .. cursor_stack[1].cursor_char
  .. cursor_stack[1].cursor_end
end

local function handle_register(char)
  local char = vim.fn.nr2char(char)
  -- same as char =~# '[a-zA-Z0-9"+:/]' in vim script
  if char:match('[a-zA-Z0-9"%+:/]') then
    remove_cursor_highlight()
    Operator = ''
    local reg = '@' .. char
    local paste = vim.fn.split(vim.fn.eval(reg), '\n')[1] or ''
    for _, i in vim.fn.range(1, #cursor_stack) do
      cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin .. paste
    end
    replace_symbol()
    highlight_cursor()
  end
  return cursor_stack[1].cursor_begin
  .. cursor_stack[1].cursor_char
  .. cursor_stack[1].cursor_end
end

local function handle(mode, char)
  if mode == 'n' and Operator == 'f' then
    handle_f_char(char)
  elseif mode == 'n' then
    handle_normal(char)
  elseif mode == 'r' and Operator == 'r' then
    handle_register(char)
  elseif mode == 'i' then
    handle_insert(char)
  end
end


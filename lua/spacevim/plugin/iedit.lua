--=============================================================================
-- iedit.lua --- multiple cursor for spacevim in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}
local modname = 'spacevim.plugin.iedit'
_G[modname] = M
package.loaded[modname] = M --return modname
setmetatable(M, { __index = _G })

-- Local spacevim APIs {{{
local hi = require('spacevim.api').import('vim.highlight')
local str = require('spacevim.api').import('data.string')
local cmp = require('spacevim.api').import('vim.compatible')
local v = require('spacevim.api').import('vim')
local k = require('spacevim.api').import('vim.keys')
-- }}}

-- Local Variable {{{

local logger = require('spacevim.logger').derive('iedit')

local index = -1
local cursor_col = -1
local mode = ''
local hi_id = ''
local Operator = ''
local iedit_cursor_hi_info = {}
local cursor_stack = {}

local iedit_hi_info = {
  {
    name = 'IeditPurpleBold',
    guibg = '#3c3836',
    guifg = '#d3869b',
    ctermbg = '',
    ctermfg = 175,
    bold = 1,
  },
  {
    name = 'IeditBlueBold',
    guibg = '#3c3836',
    guifg = '#83a598',
    ctermbg = '',
    ctermfg = 109,
    bold = 1,
  },
  {
    name = 'IeditInactive',
    guibg = '#3c3836',
    guifg = '#abb2bf',
    ctermbg = '',
    ctermfg = 145,
    bold = 1,
  },
}

-- }}}

--- basic functions{{{
local function empty(expr) -- {{{
  return vim.fn.empty(expr) == 1
end
-- }}}

local matchstr = vim.fn.matchstr
local substitute = vim.fn.substitute
local range = vim.fn.range
local getline = vim.fn.getline
local timer_start = vim.fn.timer_start

local function echo(msg) -- {{{
  vim.g._spacevim_temp_msg = msg
  vim.api.nvim_eval('SpaceVim#api#notify#get().notify(g:_spacevim_temp_msg, "None")')
end
-- }}}

---}}}

local function fixstack(idxs) -- {{{
  local change = 0
  for i = 1, #idxs, 1 do
    cursor_stack[idxs[i][1]].col = cursor_stack[idxs[i][1]].col + change
    change = change + idxs[i][2] - cursor_stack[idxs[i][1]].len
    cursor_stack[idxs[i][1]].len = idxs[i][2]
  end
end
-- }}}

local function replace_symbol() -- {{{
  local line = 0
  local begin = ''
  local pre = ''
  local _end = ''
  local idxs = {}
  for i = 1, #cursor_stack, 1 do
    if cursor_stack[i].lnum ~= line then
      if not empty(idxs) then
        _end =
          string.sub(vim.fn.getline(line), cursor_stack[i - 1].col + cursor_stack[i - 1].len, -1)
        pre = pre .. _end
      end
      fixstack(idxs)
      vim.fn.setline(line, pre)
      idxs = {}
      line = cursor_stack[i].lnum
      if cursor_stack[i].col ~= 1 then
        begin = string.sub(vim.fn.getline(line), 1, cursor_stack[i].col - 1)
      else
        begin = ''
      end
      pre = begin
        .. cursor_stack[i].cursor_begin
        .. cursor_stack[i].cursor_char
        .. cursor_stack[i].cursor_end
    else
      line = cursor_stack[i].lnum
      if i == 1 then
        if cursor_stack[i].col == 1 then
          pre = ''
        else
          pre = string.sub(vim.fn.getline(line), 1, cursor_stack[i].col - 1)
            .. cursor_stack[i].cursor_begin
            .. cursor_stack[i].cursor_char
            .. cursor_stack[i].cursor_end
        end
      else
        local a = cursor_stack[i - 1].col + cursor_stack[i - 1].len
        local b = cursor_stack[i].col - 1
        local next = ''
        if a > b then
          next = ''
        else
          next = string.sub(vim.fn.getline(line), a, b)
        end
        pre = pre
          .. next
          .. cursor_stack[i].cursor_begin
          .. cursor_stack[i].cursor_char
          .. cursor_stack[i].cursor_end
      end
    end
    table.insert(idxs, {
      i,
      vim.fn.len(
        cursor_stack[i].cursor_begin .. cursor_stack[i].cursor_char .. cursor_stack[i].cursor_end
      ),
    })
  end
  if not empty(idxs) then
    _end = string.sub(
      vim.fn.getline(line),
      cursor_stack[#cursor_stack].col + cursor_stack[#cursor_stack].len,
      -1
    )
    pre = pre .. _end
  end
  fixstack(idxs)
  vim.fn.setline(line, pre)
end
-- }}}

local function reset_Operator(...) -- {{{
  Operator = ''
end
-- }}}

local function timeout() -- {{{
  timer_start(1000, reset_Operator)
end
-- }}}

local function highlight_cursor() -- {{{
  hi.hi(iedit_cursor_hi_info)
  for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
    if cursor_stack[i].active then
      if i == index then
        vim.fn.matchaddpos('IeditPurpleBold', {
          {
            cursor_stack[i].lnum,
            cursor_stack[i].col,
            cursor_stack[i].len,
          },
        })
      else
        vim.fn.matchaddpos('IeditBlueBold', {
          {
            cursor_stack[i].lnum,
            cursor_stack[i].col,
            cursor_stack[i].len,
          },
        })
      end
      vim.fn.matchadd(
        'SpaceVimGuideCursor',
        [[\%]]
          .. cursor_stack[i].lnum
          .. [[l\%]]
          .. (cursor_stack[i].col + vim.fn.len(cursor_stack[i].cursor_begin))
          .. 'c',
        99999
      )
    else
      vim.fn.matchaddpos('IeditInactive', {
        {
          cursor_stack[i].lnum,
          cursor_stack[i].col,
          cursor_stack[i].len,
        },
      })
    end
  end
end
-- }}}

local function remove_cursor_highlight() -- {{{
  vim.fn.clearmatches()
end
-- }}}

local function handle_normal(char) -- handle normal key bindings {{{
  remove_cursor_highlight()
  if char == 'i' then -- {{{
    mode = 'i'
    vim.w.spacevim_iedit_mode = mode
    vim.w.spacevim_statusline_mode = 'ii'
    vim.cmd('redrawstatus!')
    -- }}}
  elseif char == 'I' then -- {{{
    mode = 'i'
    vim.w.spacevim_iedit_mode = mode
    vim.w.spacevim_statusline_mode = 'ii'
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        local old_cursor_char = cursor_stack[i].cursor_char
        cursor_stack[i].cursor_char = vim.fn.matchstr(
          cursor_stack[i].cursor_begin .. cursor_stack[i].cursor_char .. cursor_stack[i].cursor_end,
          '^.'
        )
        cursor_stack[i].cursor_end = vim.fn.substitute(
          cursor_stack[i].cursor_begin .. old_cursor_char .. cursor_stack[i].cursor_end,
          '^.',
          '',
          'g'
        )
        cursor_stack[i].cursor_begin = ''
      end
    end
    vim.cmd('redrawstatus!')
    -- }}}
  elseif char == '<tab>' then -- {{{
    cursor_stack[index].active = not cursor_stack[index].active
    --}}}
  elseif char == 'a' then -- {{{
    mode = 'i'
    vim.w.spacevim_iedit_mode = mode
    vim.w.spacevim_statusline_mode = 'ii'
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin .. cursor_stack[i].cursor_char
        cursor_stack[i].cursor_char = vim.fn.matchstr(cursor_stack[i].cursor_end, '^.')
        cursor_stack[i].cursor_end = vim.fn.substitute(cursor_stack[i].cursor_end, '^.', '', 'g')
      end
    end
    vim.cmd('redrawstatus!')
    -- }}}
  elseif char == 'A' then -- {{{
    mode = 'i'
    vim.w.spacevim_iedit_mode = mode
    vim.w.spacevim_statusline_mode = 'ii'
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin
          .. cursor_stack[i].cursor_char
          .. cursor_stack[i].cursor_end
        cursor_stack[i].cursor_char = ''
        cursor_stack[i].cursor_end = ''
      end
    end
    vim.cmd('redrawstatus!')
    -- }}}
  elseif char == 'C' then -- {{{
    mode = 'i'
    vim.w.spacevim_iedit_mode = mode
    vim.w.spacevim_statusline_mode = 'ii'
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_char = ''
        cursor_stack[i].cursor_end = ''
      end
    end
    replace_symbol()
    -- }}}
  elseif char == '~' then -- toggle the case of cursor char {{{
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_char = str.toggle_case(cursor_stack[i].cursor_char)
      end
    end
    replace_symbol()
    --}}}
  elseif char == 'f' then -- string find mode               {{{
    Operator = 'f'
    timeout()
    -- }}}
  elseif char == 's' then -- {{{
    mode = 'i'
    vim.w.spacevim_iedit_mode = mode
    vim.w.spacevim_statusline_mode = 'ii'
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_char = vim.fn.matchstr(cursor_stack[i].cursor_end, '^.')
        cursor_stack[i].cursor_end = vim.fn.substitute(cursor_stack[i].cursor_end, '^.', '', 'g')
      end
    end
    replace_symbol()
    -- }}}
  elseif char == 'x' then -- {{{
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_char = vim.fn.matchstr(cursor_stack[i].cursor_end, '^.')
        cursor_stack[i].cursor_end = vim.fn.substitute(cursor_stack[i].cursor_end, '^.', '', 'g')
      end
    end
    replace_symbol()
    -- }}}
  elseif char == 'X' then -- {{{
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin =
          vim.fn.substitute(cursor_stack[i].cursor_begin, '.$', '', 'g')
      end
    end
    replace_symbol()
    -- }}}
  elseif char == k.t('<left>') or char == 'h' then -- {{{
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_end = cursor_stack[i].cursor_char .. cursor_stack[i].cursor_end
        cursor_stack[i].cursor_char = vim.fn.matchstr(cursor_stack[i].cursor_begin, '.$')
        cursor_stack[i].cursor_begin =
          vim.fn.substitute(cursor_stack[i].cursor_begin, '.$', '', 'g')
      end
    end
    -- }}}
  elseif char == k.t('<right>') or char == 'l' then
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin .. cursor_stack[i].cursor_char
        cursor_stack[i].cursor_char = vim.fn.matchstr(cursor_stack[i].cursor_end, '^.')
        cursor_stack[i].cursor_end = vim.fn.substitute(cursor_stack[i].cursor_end, '^.', '', 'g')
      end
    end
  elseif char == 'e' then
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        local word = vim.fn.matchstr(cursor_stack[i].cursor_end, [[^\s*\S*]])
        cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin
          .. cursor_stack[i].cursor_char
          .. word
        cursor_stack[i].cursor_char = vim.fn.matchstr(cursor_stack[i].cursor_begin, '.$')
        cursor_stack[i].cursor_end =
          vim.fn.substitute(cursor_stack[i].cursor_end, [[^\s*\S*]], '', 'g')
      end
    end
  elseif char == 'b' then
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        local word = vim.fn.matchstr(cursor_stack[i].cursor_begin, [[\S*\s*$]])
        cursor_stack[i].cursor_end = word
          .. cursor_stack[i].cursor_char
          .. cursor_stack[i].cursor_end
        cursor_stack[i].cursor_begin =
          vim.fn.substitute(cursor_stack[i].cursor_begin, [[\S*\s*$]], '', 'g')
        cursor_stack[i].cursor_char = vim.fn.matchstr(cursor_stack[i].cursor_end, '^.')
        cursor_stack[i].cursor_end = vim.fn.substitute(cursor_stack[i].cursor_end, '^.', '', 'g')
      end
    end
  elseif char == 'w' then
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      if cursor_stack[i].active then
        local word = vim.fn.matchstr(cursor_stack[i].cursor_end, [[\S*\s*$]])
        cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin
          .. cursor_stack[i].cursor_char
          .. word
        cursor_stack[i].cursor_end =
          vim.fn.substitute(cursor_stack[i].cursor_end, [[^\S*\s*]], '', 'g')
        cursor_stack[i].cursor_char = vim.fn.matchstr(cursor_stack[i].cursor_end, '^.')
        cursor_stack[i].cursor_end = vim.fn.substitute(cursor_stack[i].cursor_end, '^.', '', 'g')
      end
    end
  elseif char == '0' or char == '<home>' then
  elseif char == '$' or char == '<end>' then
  elseif char == 'D' then
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = ''
        cursor_stack[i].cursor_char = ''
        cursor_stack[i].cursor_end = ''
      end
    end
    replace_symbol()
  elseif char == 'p' then
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = vim.fn.getreg('"', 1, true)[1] or ''
        cursor_stack[i].cursor_char = ''
        cursor_stack[i].cursor_end = ''
      end
    end
    replace_symbol()
  elseif char == 'S' then
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = ''
        cursor_stack[i].cursor_char = ''
        cursor_stack[i].cursor_end = ''
      end
    end
    mode = 'i'
    vim.w.spacevim_iedit_mode = mode
    vim.w.spacevim_statusline_mode = 'ii'
    vim.cmd('redrawstatus!')
    replace_symbol()
  elseif char == 'G' then
    vim.cmd(cursor_stack[#cursor_stack].lnum)
    index = #cursor_stack
  elseif char == 'g' then
    if Operator == 'g' then
      vim.cmd(cursor_stack[1].lnum)
      Operator = ''
      index = 1
    else
      Operator = 'g'
      timeout()
    end
  elseif char == '<c-n>' then
  elseif char == '<C-x>' then
  elseif char == '<C-p>' then
  elseif char == 'n' then
    local origin_index = index
    if index == #cursor_stack then
      index = 1
    else
      index = index + 1
    end
    while not cursor_stack[index].active do
      index = index + 1
      if index == #cursor_stack + 1 then
        index = 1
      end
      if index == origin_index then
        break
      end
    end
    vim.fn.cursor(
      cursor_stack[index].lnum,
      cursor_stack[index].col + vim.fn.len(cursor_stack[index].cursor_begin)
    )
  elseif char == 'N' then
  end
  highlight_cursor()
  return cursor_stack[1].cursor_begin .. cursor_stack[1].cursor_char .. cursor_stack[1].cursor_end
end
-- }}}

local function handle_insert(char) -- {{{
  remove_cursor_highlight()
  local is_movement = false
  if char == k.t('<Esc>') or char == k.t('<C-g>') then
    mode = 'n'
    vim.w.spacevim_iedit_mode = mode
    vim.w.spacevim_statusline_mode = 'in'
    highlight_cursor()
    vim.cmd('redraw!')
    vim.cmd('redrawstatus!')
    return cursor_stack[1].cursor_begin .. cursor_stack[1].cursor_char .. cursor_stack[1].cursor_end
  elseif char == k.t('<C-w>') then
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin =
          substitute(cursor_stack[i].cursor_begin, [[\S*\s*$]], '', 'g')
      end
    end
  elseif char == k.t('<C-u>') then
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = ''
      end
    end
  elseif char == k.t('<C-k>') then
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_char = ''
        cursor_stack[i].cursor_end = ''
      end
    end
  elseif char == k.t('<bs>') or char == k.t('<C-h>') then
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = substitute(cursor_stack[i].cursor_begin, '.$', '', 'g')
      end
    end
  elseif char == k.t('<Delete>') or char == k.t('<C-?>') then
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = matchstr(cursor_stack[i].cursor_end, '^.')
        cursor_stack[i].cursor_end = substitute(cursor_stack[i].cursor_end, '^.', '', 'g')
      end
    end
  elseif char == k.t('<C-b>') or char == k.t('<Left>') then
    is_movement = true
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        if not empty(cursor_stack[i].cursor_begin) then
          cursor_stack[i].cursor_end = cursor_stack[i].cursor_char .. cursor_stack[i].cursor_end
          cursor_stack[i].cursor_char = matchstr(cursor_stack[i].cursor_begin, '.$')
          cursor_stack[i].cursor_begin = substitute(cursor_stack[i].cursor_begin, '.$', '', 'g')
        end
      end
    end
  elseif char == k.t('<C-f>') or char == k.t('<Right>') then
    is_movement = true
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin .. cursor_stack[i].cursor_char
        cursor_stack[i].cursor_char = matchstr(cursor_stack[i].cursor_end, '^.')
        cursor_stack[i].cursor_end = substitute(cursor_stack[i].cursor_end, '^.', '', 'g')
      end
    end
  elseif char == k.t('<C-r>') then
    Operator = 'r'
    timeout()
  else
    for i = 1, #cursor_stack, 1 do
      if cursor_stack[i].active then
        cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin .. char
      end
    end
  end
  if not is_movement then
    replace_symbol()
  end
  highlight_cursor()
  return cursor_stack[1].cursor_begin .. cursor_stack[1].cursor_char .. cursor_stack[1].cursor_end
end
--- }}}

local function parse_symbol(_begin, _end, symbol, use_expr, selectall) -- {{{
  local len = #symbol
  local cursor = { vim.fn.line('.'), vim.fn.col('.') }
  for _, l in ipairs(vim.fn.range(_begin, _end)) do
    local line = vim.fn.getline(l)
    local idx = str.strAllIndex(line, symbol, use_expr)
    for _, v in ipairs(idx) do
      local pos_a = v[1]
      local pos_b = v[2]
      table.insert(cursor_stack, {
        cursor_begin = string.sub(line, pos_a + 1, pos_b - 1),
        cursor_char = string.sub(line, pos_b, pos_b),
        cursor_end = '',
        active = selectall,
        lnum = l,
        col = pos_a + 1,
        len = pos_b - pos_a,
      })
      if l == cursor[1] and pos_a + 1 <= cursor[2] and pos_b >= cursor[2] then
        index = #cursor_stack
      end
    end
  end
  if index == -1 and vim.fn.empty(cursor_stack) == 0 then
    index = 1
    vim.fn.cursor(cursor_stack[1].lnum, cursor_stack[1].col)
  end
  if vim.fn.empty(cursor_stack) == 0 then
    cursor_stack[index].active = true
  end
end
-- }}}

local function handle_f_char(char) -- {{{
  remove_cursor_highlight()
  if char >= 32 and char <= 126 then
    Operator = ''
    for _, i in ipairs(vim.fn.range(1, #cursor_stack)) do
      local matchedstr =
        vim.fn.matchstr(cursor_stack[i].cursor_end, vim.fn.printf('[^%s]', vim.fn.nr2char(char)))
      cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin
        .. cursor_stack[i].cursor_char
        .. matchedstr
      cursor_stack[i].cursor_end = vim.fn.matchstr(
        cursor_stack[i].cursor_end,
        vim.fn.printf([[[%s]\zs.*]], vim.fn.nr2char(char))
      )
      cursor_stack[i].cursor_char = vim.fn.nr2char(char)
    end
  end
  highlight_cursor()
  return cursor_stack[1].cursor_begin .. cursor_stack[1].cursor_char .. cursor_stack[1].cursor_end
end
-- }}}

local function handle_register(char) -- {{{
  -- local char = vim.fn.nr2char(char)
  -- same as char =~# '[a-zA-Z0-9"+:/]' in vim script
  if char:match('[a-zA-Z0-9"%+:/]') then
    remove_cursor_highlight()
    Operator = ''
    local paste = vim.fn.getreg(char, 1, true)[1] or ''
    for i = 1, #cursor_stack, 1 do
      cursor_stack[i].cursor_begin = cursor_stack[i].cursor_begin .. paste
    end
    replace_symbol()
    highlight_cursor()
  end
  return cursor_stack[1].cursor_begin .. cursor_stack[1].cursor_char .. cursor_stack[1].cursor_end
end
-- }}}

local function handle(mode, char) -- {{{
  if mode == 'n' and Operator == 'f' then
    handle_f_char(char)
  elseif mode == 'n' then
    handle_normal(char)
  elseif mode == 'i' and Operator == 'r' then
    handle_register(char)
  elseif mode == 'i' then
    handle_insert(char)
  end
end
-- }}}

function M.start(...) -- {{{
  local args = { ... }
  argv = args[1] or ''
  local selectall = true
  local use_expr = false
  if
    empty(argv)
    and (
      matchstr(getline('.'), '\\%' .. vim.fn.col('.') .. 'c.') == ''
      or matchstr(getline('.'), '\\%' .. vim.fn.col('.') .. 'c.') == ' '
    )
  then
    echo('no pattern found under cursor')
    return
  end
  local save_cl = vim.wo.cursorline
  vim.wo.cursorline = false
  hi.hi(iedit_hi_info[1])
  hi.hi(iedit_hi_info[2])
  hi.hi(iedit_hi_info[3])
  local cursor_hi = hi.group2dict('Cursor')
  iedit_cursor_hi_info = vim.fn.deepcopy(cursor_hi)
  iedit_cursor_hi_info.name = 'SpaceVimGuideCursor'
  lcursor_hi = hi.group2dict('lCursor')
  local guicursor = vim.o.guicursor
  hi.hide_in_normal('Cursor')
  hi.hide_in_normal('lCursor')
  if vim.api ~= nil then
    vim.cmd('set guicursor+=a:Cursor/lCursor')
  end
  mode = 'n'
  vim.w.spacevim_iedit_mode = mode
  vim.w.spacevim_statusline_mode = 'in'
  if #cursor_stack == 0 then
    local curpos = vim.fn.getpos('.')
    local save_reg_k = vim.api.nvim_eval('@"')
    if not empty(argv) and vim.fn.type(argv) == 4 then
      selectall = argv.selectall or selectall
      if argv.expr ~= nil then
        use_expr = true
        symbol = argv.expr
      elseif argv.word then
        symbol = argv.word
      elseif argv.stack then
      else
        vim.cmd('normal! gv"ky')
        symbol = vim.fn.split(vim.api.nvim_eval('@K'), '\n')[1]
      end
    else
      vim.cmd('normal! viw"ky')
      symbol = vim.fn.split(vim.api.nvim_eval('@K'), '\n')[1]
    end
  end
  vim.fn.setpos('.', curpos)
  local _begin = args[2] or 1
  local _end = args[3] or vim.fn.line('$')
  logger.debug('iedit symbol:>' .. symbol .. '<')
  logger.debug('iedit use_expr:' .. vim.fn.string(use_expr))
  logger.debug('iedit begin:' .. _begin)
  logger.debug('iedit end:' .. _end)
  parse_symbol(_begin, _end, symbol, 1, selectall)
  highlight_cursor()
  vim.cmd('redrawstatus!')
  while mode ~= '' and #cursor_stack > 0 do
    vim.cmd('redraw!')
    local char = v.getchar()
    if mode == 'n' and char == k.t('<Esc>') then
      mode = ''
    else
      local symbol = handle(mode, char)
    end
  end
  if #cursor_stack == 0 then
    vim.cmd('normal! :')
    echo('Pattern not found:' .. symbol)
  end
  cursor_stack = {}
  index = -1
  mode = ''
  vim.w.spacevim_iedit_mode = mode
  vim.w.spacevim_statusline_mode = 'in'
  hi.hi(cursor_hi)
  hi.hi(lcursor_hi)
  vim.o.guicursor = guicursor
  vim.cmd('normal! :')
  remove_cursor_highlight()
  pcall(vim.fn.matchdelete, hi_id)
  hi_id = ''
  vim.wo.cursorline = save_cl
  return symbol
end
-- }}}

return M

-- vim:set et sw=2 cc=80 foldmethod=marker foldmarker={{{,}}}:

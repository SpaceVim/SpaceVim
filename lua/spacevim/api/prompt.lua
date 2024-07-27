--=============================================================================
-- prompt.lua --- prompt api for spacevim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local Key = require('spacevim.api').import('vim.keys')

local M = {}

M.__cmp = require('spacevim.api').import('vim.compatible')
M.__vim = require('spacevim.api').import('vim')

M._keys = {
  close = Key.t('<Esc>'),
}

M._prompt = {
  mpt = '==>',
  cursor_begin = '',
  cursor_char = '',
  cursor_end = '',
}

M._function_key = {}

M._quit = true

M._handle_fly = ''

M._onclose = ''

M._oninputpro = ''

function M.open()
  local srl = vim.o.ruler
  vim.o.ruler = false
  M._quit = false
  M._build_prompt()
  if M.__cmp.fn.empty(M._prompt.cursor_begin) == 0 then
    M._handle_input(M._prompt.cursor_begin)
  else
    M._handle_input()
  end
  vim.o.ruler = srl
end

function M._c_r_mode_off(timer)
  M._c_r_mode = false
end

function M._handle_input(...)
  local argv = { ... }
  local begin = argv[1] or ''
  if begin ~= '' then
    if type(M._oninputpro) == 'function' then
      M._oninputpro()
    end
    if type(M._handle_fly) == 'function' then
      M._handle_fly(M._prompt.cursor_begin .. M._prompt.cursor_char .. M._prompt.cursor_end)
    end
    M._build_prompt()
  end
  M._c_r_mode = false
  while not M._quit do
    local char = M.__vim.getchar()
    if M._function_key[char] ~= nil then
      local ok, rst = pcall(M._function_key[char])
      if not ok then
        print(rst)
      end
      goto continue
    end
    if M._c_r_mode then
      if char:match('^[%w":+/]$') then
        local reg = '@' .. char
        local paste = vim.fn.get(vim.fn.split(vim.fn.eval(reg), '\n'), 0, '')
        M._prompt.cursor_begin = M._prompt.cursor_begin .. paste
        M._prompt.cursor_char = vim.fn.matchstr(M._prompt.cursor_end, '.$')
        M._c_r_mode = false
        M._build_prompt()
      else
        M._c_r_mode = false
        goto continue
      end
    elseif char == Key.t('<c-r>') then
      M._c_r_mode = true
      vim.fn.timer_start(2000, M._c_r_mode_off)
      M._build_prompt()
      goto continue
    elseif char == Key.t('<right>') then
      M._prompt.cursor_begin = M._prompt.cursor_begin .. M._prompt.cursor_char
      M._prompt.cursor_char = M.__cmp.fn.matchstr(M._prompt.cursor_end, '^.')
      M._prompt.cursor_end = M.__cmp.fn.substitute(M._prompt.cursor_end, '^.', '', 'g')
      M._build_prompt()
      goto continue
    elseif char == Key.t('<left>') then
      if M._prompt.cursor_begin ~= '' then
        M._prompt.cursor_end = M._prompt.cursor_char .. M._prompt.cursor_end
        M._prompt.cursor_char = vim.fn.matchstr(M._prompt.cursor_begin, '.$')
        M._prompt.cursor_begin = vim.fn.substitute(M._prompt.cursor_begin, '.$', '', 'g')
        M._build_prompt()
      end
      goto continue
    elseif char == Key.t('<C-w>') then
      M._prompt.cursor_begin =
        M.__cmp.fn.substitute(M._prompt.cursor_begin, [[[^\ .*]\+\s*$]], '', 'g')
      M._build_prompt()
    elseif char == Key.t('<C-a>') or char == Key.t('<Home>') then
      M._prompt.cursor_end = M.__cmp.fn.substitute(
        M._prompt.cursor_begin .. M._prompt.cursor_char .. M._prompt.cursor_end,
        '^.',
        '',
        'g'
      )
      M._prompt.cursor_char = M.__cmp.fn.matchstr(M._prompt.cursor_begin, '^.')
      M._prompt.cursor_begin = ''
      M._build_prompt()
      goto continue
    elseif char == Key.t('<C-e>') or char == Key.t('<End>') then
      M._prompt.cursor_begin = M._prompt.cursor_begin
        .. M._prompt.cursor_char
        .. M._prompt.cursor_end
      M._prompt.cursor_char = ''
      M._prompt.cursor_end = ''
      M._build_prompt()
      goto continue
    elseif char == Key.t('<C-u>') then
      M._prompt.cursor_begin = ''
      M._build_prompt()
    elseif char == Key.t('<C-k>') then
      M._prompt.cursor_char = ''
      M._prompt.cursor_end = ''
      M._build_prompt()
    elseif char == Key.t('<bs>') then
      M._prompt.cursor_begin = vim.fn.substitute(M._prompt.cursor_begin, '.$', '', 'g')
      M._build_prompt()
    elseif
      (type(M._keys.close) == 'string' and char == M._keys.close)
      or (type(M._keys.close) == 'table' and vim.fn.index(M._keys.close, char) > -1)
    then
      M.close()
      break
    elseif
      char == Key.t('<FocusLost>')
      or char == Key.t('<FocusGained>')
      or vim.fn.char2nr(char) == 128
    then
      goto continue
    else
      M._prompt.cursor_begin = M._prompt.cursor_begin .. char
      M._build_prompt()
    end
    if type(M._oninputpro) == 'function' then
      M._oninputpro()
    end
    if type(M._handle_fly) == 'function' then
      M._handle_fly(M._prompt.cursor_begin .. M._prompt.cursor_char .. M._prompt.cursor_end)
    end
    ::continue::
  end
end

function M._build_prompt()
  local ident = M.__cmp.fn['repeat'](' ', M.__cmp.win_screenpos(0)[2] - 1)
  vim.cmd('redraw')
  vim.api.nvim_echo({
    { ident .. M._prompt.mpt, 'Comment' },
    { M._prompt.cursor_begin, 'None' },
    { M._prompt.cursor_char, 'Wildmenu' },
    { M._prompt.cursor_end, 'None' },
    { '_', 'Comment' },
  }, false, {})
end

function M._clear_prompt()
  M._prompt = {
    mpt = M._prompt.mpt,
    cursor_begin = '',
    cursor_char = '',
    cursor_end = '',
  }
end

function M.close()
  if type(M._onclose) == 'function' then
    M._onclose()
  end
  M._clear_prompt()
  M._quit = true
end

return M

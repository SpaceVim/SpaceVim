--=============================================================================
-- cmyk.lua ---
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local color = require('spacevim.api.color')
local util = require('cpicker.util')

local cyan = 0
local magenta = 0
local yellow = 0
local black = 0

M.color_code_regex = [[\scmyk(\d\+%,\s\d\+%,\s\d\+%,\s\d\+%)]]

local function on_change_argv()
  return 'cmyk', { cyan, magenta, yellow, black }
end

function M.buf_text()
  local rst = {}
  local c_bar = util.generate_bar(cyan, '+')
  local m_bar = util.generate_bar(magenta, '+')
  local y_bar = util.generate_bar(yellow, '+')
  local k_bar = util.generate_bar(black, '+')
  table.insert(rst, 'CMYK:   C:    ' .. string.format('%4s', math.floor(cyan * 100 + 0.5)) .. ' ' .. c_bar)
  table.insert(rst, '        M:    ' .. string.format('%4s', math.floor(magenta * 100 + 0.5)) .. ' ' .. m_bar)
  table.insert(rst, '        Y:    ' .. string.format('%4s', math.floor(yellow * 100 + 0.5)) .. ' ' .. y_bar)
  table.insert(rst, '        K:    ' .. string.format('%4s', math.floor(black * 100 + 0.5)) .. ' ' .. k_bar)
  return rst
end

function M.color_code()
  return
    '   =========' .. string.format(
    '  cmyk(%s%%, %s%%, %s%%, %s%%)',
    math.floor(cyan * 100 + 0.5),
    math.floor(magenta * 100 + 0.5),
    math.floor(yellow * 100 + 0.5),
    math.floor(black * 100 + 0.5)
  )
end

local function increase_cyan()
  if cyan <= 0.99 then
    cyan = cyan + 0.01
  elseif cyan < 1 then
    cyan = 1
  end
  return on_change_argv()
end
local function reduce_cyan()
  if cyan > 0.01 then
    cyan = cyan - 0.01
  elseif cyan > 0 then
    cyan = 0
  end
  return on_change_argv()
end
local function increase_magenta()
  if magenta <= 0.99 then
    magenta = magenta + 0.01
  elseif magenta < 1 then
    magenta = 1
  end
  return on_change_argv()
end
local function reduce_magenta()
  if magenta > 0.01 then
    magenta = magenta - 0.01
  elseif magenta > 0 then
    magenta = 0
  end
  return on_change_argv()
end
local function increase_yellow()
  if yellow <= 0.99 then
    yellow = yellow + 0.01
  elseif yellow < 1 then
    yellow = 1
  end
  return on_change_argv()
end
local function reduce_yellow()
  if yellow > 0.01 then
    yellow = yellow - 0.01
  elseif yellow > 0 then
    yellow = 0
  end
  return on_change_argv()
end
local function increase_black()
  if black <= 0.99 then
    black = black + 0.01
  elseif black < 1 then
    black = 1
  end
  return on_change_argv()
end
local function reduce_black()
  if black > 0.01 then
    black = black - 0.01
  elseif black > 0 then
    black = 0
  end
  return on_change_argv()
end
function M.increase_reduce_functions()
  return {
    { increase_cyan, reduce_cyan },
    { increase_magenta, reduce_magenta },
    { increase_yellow, reduce_yellow },
    { increase_black, reduce_black },
  }
end

function M.on_change(f, code)
  if f == 'cmyk' then
    cyan, magenta, yellow, black = unpack(code)
    return
  end
  cyan, magenta, yellow, black = color[f .. '2cmyk'](unpack(code))
end

return M

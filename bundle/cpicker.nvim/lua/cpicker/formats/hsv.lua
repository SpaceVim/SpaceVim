--=============================================================================
-- hsv.lua --- 
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local color = require('spacevim.api.color')
local util = require('cpicker.util')

local hue = 0
local saturation = 0
local value = 0

M.color_code_regex = [[\shsv(\d\+,\s\d\+%,\s\d\+%)]]

local function on_change_argv()
  return 'hsv', {hue, saturation, value}
end

function M.buf_text()
  
  local rst = {}
  local h_bar = util.generate_bar(hue, '+', 360)
  local s_bar = util.generate_bar(saturation, '+')
  local l_bar = util.generate_bar(value, '+')
  table.insert(rst, 'HSV:    H:    ' .. string.format('%4s', math.floor(hue + 0.5)) .. ' ' .. h_bar)
  table.insert(
    rst,
    '        S:    ' .. string.format('%3s', math.floor(saturation * 100 + 0.5)) .. '% ' .. s_bar
  )
  table.insert(
    rst,
    '        V:    ' .. string.format('%3s', math.floor(value * 100 + 0.5)) .. '% ' .. l_bar
  )
  return rst
end

function M.color_code()
  return
    '   =========' .. string.format(
    '  hsv(%s, %s%%, %s%%)',
    math.floor(hue + 0.5),
    math.floor(saturation * 100 + 0.5),
    math.floor(value * 100 + 0.5)
  )
  
end
local function increase_hsl_h()
  if hue <= 359 then
    hue = hue + 1
  elseif hue < 360 then hue = 360
  end
  return on_change_argv()
end
local function reduce_hsl_h()
  if hue >= 1 then
    hue = hue - 1
  elseif hue > 0 then
    hue = 0
  end
  return on_change_argv()
end
local function increase_hsl_s()
  if saturation <= 0.99 then
    saturation = saturation + 0.01
  elseif saturation < 1 then
    saturation = 1
  end
  return on_change_argv()
end
local function reduce_hsl_s()
  if saturation >= 0.01 then
    saturation = saturation - 0.01
  elseif saturation > 0 and saturation < 0.01 then
    saturation = 0
  end
  return on_change_argv()
end
local function increase_hsl_v()
  if value <= 0.99 then
    value = value + 0.01
  elseif value < 1 then
    value = 1
  end
  return on_change_argv()
end
local function reduce_hsl_v()
  if value >= 0.01 then
    value = value - 0.01
  elseif value > 0 and value < 0.01 then
    value = 0
  end
  return on_change_argv()
end
function M.increase_reduce_functions()
  return {
    { increase_hsl_h, reduce_hsl_h },
    { increase_hsl_s, reduce_hsl_s },
    { increase_hsl_v, reduce_hsl_v },
  }
end

function M.on_change(f, code)
  if f == 'hsv' then
    hue, saturation, value = unpack(code)
    return
  end
  hue, saturation, value = color[f .. '2hsv'](unpack(code))
end

return M

--=============================================================================
-- hwb.lua
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local color = require('spacevim.api.color')
local util = require('cpicker.util')

local hue = 0 -- [0, 360]
local whiteness = 0 -- [0, 100%]
local blackness = 0 -- [0, 100%]

M.color_code_regex = [[\shwb(\d\+,\s\d\+%,\s\d\+%)]]

local function on_change_argv()
  return 'hwb', { hue, whiteness, blackness }
end

function M.buf_text()
  local rst = {}
  local h_bar = util.generate_bar(hue, '+', 360)
  local w_bar = util.generate_bar(whiteness, '+')
  local b_bar = util.generate_bar(blackness, '+')
  table.insert(rst, 'HWB:    H:    ' .. string.format('%4s', math.floor(hue + 0.5)) .. ' ' .. h_bar)
  table.insert(
    rst,
    '        W:    ' .. string.format('%3s', math.floor(whiteness * 100 + 0.5)) .. '% ' .. w_bar
  )
  table.insert(
    rst,
    '        B:    ' .. string.format('%3s', math.floor(blackness * 100 + 0.5)) .. '% ' .. b_bar
  )
  return rst
end

function M.color_code()
  return
    '   =========' .. string.format(
    '  hwb(%s, %s%%, %s%%)',
    math.floor(hue + 0.5),
    math.floor(whiteness * 100 + 0.5),
    math.floor(blackness * 100 + 0.5)
  )
end

local function increase_hwb_h()
  if hue <= 359 then
    hue = hue + 1
  elseif hue < 360 then
    hue = 360
  end
  return on_change_argv()
end
local function reduce_hwb_h()
  if hue >= 1 then
    hue = hue - 1
  elseif hue > 0 then
    hue = 0
  end
  return on_change_argv()
end
local function increase_hwb_w()
  if whiteness <= 0.99 then
    whiteness = whiteness + 0.01
  elseif whiteness < 1 then
    whiteness = 1
  end
  return on_change_argv()
end
local function reduce_hwb_w()
  if whiteness >= 0.01 then
    whiteness = whiteness - 0.01
  elseif whiteness > 0 and whiteness < 0.01 then
    whiteness = 0
  end
  return on_change_argv()
end
local function increase_hwb_b()
  if blackness <= 0.99 then
    blackness = blackness + 0.01
  elseif blackness < 1 then
    blackness = 1
  end
  return on_change_argv()
end
local function reduce_hwb_b()
  if blackness >= 0.01 then
    blackness = blackness - 0.01
  elseif blackness > 0 and blackness < 0.01 then
    blackness = 0
  end
  return on_change_argv()
end
function M.increase_reduce_functions()
  return {
    { increase_hwb_h, reduce_hwb_h },
    { increase_hwb_w, reduce_hwb_w },
    { increase_hwb_b, reduce_hwb_b },
  }
end

function M.on_change(f, code)
  if f == 'hwb' then
    hue, whiteness, blackness = unpack(code)
    return
  end
  hue, whiteness, blackness = color[f .. '2hwb'](unpack(code))
end

return M


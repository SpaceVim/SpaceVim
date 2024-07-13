--=============================================================================
-- rgb.lua ---
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local color = require('spacevim.api.color')
local util = require('cpicker.util')

local red = 0 -- [0, 255]
local green = 0 -- [0, 255]
local blue = 0 -- [0, 255]

local function on_change_argv()
  return 'rgb', { red, green, blue }
end

function M.buf_text()
  local rst = {}
  local r_bar = util.generate_bar(red, '+')
  local g_bar = util.generate_bar(green, '+')
  local b_bar = util.generate_bar(blue, '+')
  table.insert(rst, 'RGB:  R:    ' .. string.format('%4s', red) .. ' ' .. r_bar)
  table.insert(rst, '      G:    ' .. string.format('%4s', green) .. ' ' .. g_bar)
  table.insert(rst, '      B:    ' .. string.format('%4s', blue) .. ' ' .. b_bar)
  return rst
end

function M.color_code()
  return '   =========' .. '  ' .. color.rgb2hex(red, green, blue)
end

local function increase_rgb_red()
  if red < 255 then
    red = red + 1
  end
  return on_change_argv()
end
local function reduce_rgb_red()
  if red > 0 then
    red = red - 1
  end
  return on_change_argv()
end
local function increase_rgb_green()
  if green < 255 then
    green = green + 1
  end
  return on_change_argv()
end
local function reduce_rgb_green()
  if green > 0 then
    green = green - 1
  end
  return on_change_argv()
end

local function increase_rgb_blue()
  if blue < 255 then
    blue = blue + 1
  end
  return on_change_argv()
end

local function reduce_rgb_blue()
  if blue > 0 then
    blue = blue - 1
  end
  return on_change_argv()
end
function M.increase_reduce_functions()
  return {
    { increase_rgb_red, reduce_rgb_red },
    { increase_rgb_green, reduce_rgb_green },
    { increase_rgb_blue, reduce_rgb_blue },
  }
end

function M.on_change(f, code)
  if f == 'rgb' then
    return
  end
  red, green, blue = color[f .. '2rgb'](unpack(code))
end

return M

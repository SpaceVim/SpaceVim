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

local red = 0 -- [0, 1]
local green = 0 -- [0, 1]
local blue = 0 -- [0, 1]

M.color_code_regex = [[\s#[0123456789ABCDEF]\+]]

local function on_change_argv()
  return 'rgb', { red, green, blue }
end

function M.buf_text()
  local rst = {}
  local r_bar = util.generate_bar(red, '+')
  local g_bar = util.generate_bar(green, '+')
  local b_bar = util.generate_bar(blue, '+')
  table.insert(
    rst,
    'RGB:    R:    ' .. string.format('%4s', math.floor(red * 255 + 0.5)) .. ' ' .. r_bar
  )
  table.insert(
    rst,
    '        G:    ' .. string.format('%4s', math.floor(green * 255 + 0.5)) .. ' ' .. g_bar
  )
  table.insert(
    rst,
    '        B:    ' .. string.format('%4s', math.floor(blue * 255 + 0.5)) .. ' ' .. b_bar
  )
  return rst
end

function M.color_code()
  return '   =========' .. '  ' .. color.rgb2hex(red, green, blue)
end

local function increase_rgb_red()
  red = util.increase(red, 255)
  return on_change_argv()
end
local function reduce_rgb_red()
  red = util.reduce(red, 255)
  return on_change_argv()
end
local function increase_rgb_green()
  green = util.increase(green, 255)
  return on_change_argv()
end
local function reduce_rgb_green()
  green = util.reduce(green, 255)
  return on_change_argv()
end

local function increase_rgb_blue()
  blue = util.increase(blue, 255)
  return on_change_argv()
end

local function reduce_rgb_blue()
  blue = util.reduce(blue, 255)
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
    red, green, blue = unpack(code)
    return
  end
  red, green, blue = color[f .. '2rgb'](unpack(code))
end

return M

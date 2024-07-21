--=============================================================================
-- rgb-linear
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
  return 'linear', { red, green, blue }
end

function M.buf_text()
  local rst = {}
  local r_bar = util.generate_bar(red, '+')
  local g_bar = util.generate_bar(green, '+')
  local b_bar = util.generate_bar(blue, '+')
  table.insert(
    rst,
    'Linear: R:    ' .. string.format('%4s', math.floor(red * 255 + 0.5)) .. ' ' .. r_bar
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
  return '   =========' .. '  ' .. color.linear2hex(red, green, blue)
end

local function increase(c)
  if c <= 1 - 1 / 255 then
    c = c + 1 / 255
  elseif c < 1 then
    c = 1
  end
  return c
end

local function reduce(c)
  if c >= 1 / 255 then
    c = c - 1 / 255
  elseif c > 0 then
    c = 0
  end
  return c
end

local function increase_rgb_red()
  red = increase(red)
  return on_change_argv()
end
local function reduce_rgb_red()
  red = reduce(red)
  return on_change_argv()
end
local function increase_rgb_green()
  green = increase(green)
  return on_change_argv()
end
local function reduce_rgb_green()
  green = reduce(green)
  return on_change_argv()
end

local function increase_rgb_blue()
  blue = increase(blue)
  return on_change_argv()
end

local function reduce_rgb_blue()
  blue = reduce(blue)
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
  if f == 'linear' then
    red, green, blue = unpack(code)
    return
  end
  red, green, blue = color[f .. '2linear'](unpack(code))
end

return M


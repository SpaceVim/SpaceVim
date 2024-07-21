--=============================================================================
-- xyz.lua ---
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local color = require('spacevim.api.color')
local util = require('cpicker.util')

local x = 0
local y = 0
local z = 0

M.color_code_regex = [[\scolor(xyz,\s\d\+%,\s\d\+%,\s\d\+%)]]

local function on_change_argv()
  return 'xyz', { x, y, z }
end

function M.buf_text()
  local rst = {}
  local h_bar = util.generate_bar(x, '+')
  local s_bar = util.generate_bar(y, '+')
  local l_bar = util.generate_bar(z, '+')
  table.insert(
    rst,
    'XYZ:    X:    ' .. string.format('%3s', math.floor(x * 100 + 0.5)) .. '% ' .. h_bar
  )
  table.insert(
    rst,
    '        Y:    ' .. string.format('%3s', math.floor(y * 100 + 0.5)) .. '% ' .. s_bar
  )
  table.insert(
    rst,
    '        Z:    ' .. string.format('%3s', math.floor(z * 100 + 0.5)) .. '% ' .. l_bar
  )
  return rst
end

function M.color_code()
  return
    '   =========' .. string.format(
    '  color(xyz, %s%%, %s%%, %s%%)',
    math.floor(x * 100 + 0.5),
    math.floor(y * 100 + 0.5),
    math.floor(z * 100 + 0.5)
  )
end
local function increase_x()
  x = util.increase(x)
  return on_change_argv()
end
local function reduce_x()
  x = util.reduce(x)
  return on_change_argv()
end
local function increase_y()
  y = util.increase(y)
  return on_change_argv()
end
local function reduce_y()
  y = util.reduce(y)
  return on_change_argv()
end
local function increase_z()
  z = util.increase(z)
  return on_change_argv()
end
local function reduce_z()
  z = util.reduce(z)
  return on_change_argv()
end
function M.increase_reduce_functions()
  return {
    { increase_x, reduce_x },
    { increase_y, reduce_y },
    { increase_z, reduce_z },
  }
end

function M.on_change(f, code)
  if f == 'xyz' then
    x, y, z = unpack(code)
    return
  end
  x, y, z = color[f .. '2xyz'](unpack(code))
end

return M

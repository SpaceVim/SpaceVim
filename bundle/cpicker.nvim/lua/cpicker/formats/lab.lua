--=============================================================================
-- lab.lua
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local color = require('spacevim.api.color')
local util = require('cpicker.util')

local l = 0 -- [0, 360]
local a = 0 -- [0, 100%]
local b = 0 -- [0, 100%]

M.color_code_regex = [[\slab(\d\+,\s-\?\d\+%,\s-\?\d\+%)]]

local function on_change_argv()
  return 'lab', { l, a, b }
end

function M.buf_text()
  local rst = {}
  local h_bar = util.generate_bar(l, '+', 100)
  local s_bar = util.generate_bar(a, '+', 250)
  local l_bar = util.generate_bar(b, '+', 250)
  table.insert(rst, 'Lab:    L:    ' .. string.format('%3s', math.floor(l + 0.5)) .. '  ' .. h_bar)
  table.insert(rst, '        a:    ' .. string.format('%3s', math.floor(a + 0.5)) .. '% ' .. s_bar)
  table.insert(rst, '        b:    ' .. string.format('%3s', math.floor(b + 0.5)) .. '% ' .. l_bar)
  return rst
end

function M.color_code()
  return
    '   =========' .. string.format(
    '  lab(%s, %s%%, %s%%)',
    math.floor(l + 0.5),
    math.floor(a + 0.5),
    math.floor(b + 0.5)
  )
end

local function increase_l()
  if l <= 99 then
    l = l + 1
  elseif l < 100 then
    l = 100
  end
  return on_change_argv()
end
local function reduce_l()
  if l >= 1 then
    l = l - 1
  elseif l > 0 then
    l = 0
  end
  return on_change_argv()
end
local function increase_a()
  if a <= 99 then
    a = a + 1
  elseif a < 100 then
    a = 100
  end
  return on_change_argv()
end
local function reduce_a()
  if a >= -99 then
    a = a - 1
  elseif a > -100 then
    a = -100
  end
  return on_change_argv()
end
local function increase_b()
  if b <= 99 then
    b = b + 1
  elseif b < 100 then
    b = 100
  end
  return on_change_argv()
end
local function reduce_b()
  if b >= -99 then
    b = b - 1
  elseif b > -100 then
    b = -100
  end
  return on_change_argv()
end
function M.increase_reduce_functions()
  return {
    { increase_l, reduce_l },
    { increase_a, reduce_a },
    { increase_b, reduce_b },
  }
end

function M.on_change(f, code)
  if f == 'lab' then
    l, a, b = unpack(code)
    return
  end
  l, a, b = color[f .. '2lab'](unpack(code))
end

return M

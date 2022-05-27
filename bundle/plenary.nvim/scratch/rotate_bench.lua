local tbl = require('plenary/tbl')

local vararg = require('plenary/vararg')
local rotate = vararg.rotate
local bench = require('plenary.profile').benchmark

local function rotate_n(first, ...)
  local args = tbl.pack(...)
  args[#args+1] = first
  return tbl.unpack(args)
end

local num = 2e7 -- 2e4

print('rotate: ', bench(num, function()
  local a, b, c, d, e, f, g = rotate(1, 2, 3, 4, 5, 6)
end))

print('rotate_n: ', bench(num, function()
  local a, b, c, d, e, f, g = rotate_n(1, 2, 3, 4, 5, 6)
end))

--!/usr/bin/lua
local M = {}

function M.generate_simple(len) -- {{{
  local temp = vim.split('abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ', '')
  local ps = {}
  local i = 0
  while i < len do
    table.insert(ps, temp[math.random(#temp)])
    i = i + 1
  end
  return table.concat(ps, '')
end
-- }}}
--
--
return M

--=============================================================================
-- util.lua
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local color = require('spacevim.api.color')

function M.generate_bar(n, char, m)
  return string.rep(char, math.floor(24 * n / (m or 1)))
end

function M.get_hex_code(t, code)
  return color[t .. '2hex'](unpack(code))
end

function M.get_hsl_l(hex)
  local _, _, l = color.rgb2hsl(color.hex2rgb(hex))
  return l
end
function M.update_color_code_syntax(r)
  local max = 0
  local regexes = {}
  for _, v in ipairs(r) do
    max = math.max(max, v[1])
  end
  regexes = vim.tbl_map(function(val)
    return val[2] .. string.rep('\\s', max - val[1])
  end, r)
  vim.cmd('syn match SpaceVimPickerCode /' .. table.concat(regexes, '\\|') .. '/')
end

return M

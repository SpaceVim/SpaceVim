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

return M

local a = require "plenary.async_lib.async"
local util = require "plenary.async_lib.util"

local M = {}

M.describe = function(s, func)
  describe(s, util.will_block(a.future(func)))
end

M.it = function(s, func)
  it(s, util.will_block(a.future(func)))
end

return M

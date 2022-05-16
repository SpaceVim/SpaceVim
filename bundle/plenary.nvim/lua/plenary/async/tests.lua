local util = require "plenary.async.util"

local M = {}

M.describe = function(s, async_func)
  describe(s, async_func)
end

M.it = function(s, async_func)
  it(s, util.will_block(async_func))
end

M.before_each = function(async_func)
  before_each(util.will_block(async_func))
end

M.after_each = function(async_func)
  after_each(util.will_block(async_func))
end

return M

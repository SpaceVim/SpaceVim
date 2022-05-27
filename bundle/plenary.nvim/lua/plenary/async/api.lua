local util = require "plenary.async.util"

return setmetatable({}, {
  __index = function(t, k)
    return function(...)
      -- if we are in a fast event await the scheduler
      if vim.in_fast_event() then
        util.scheduler()
      end

      vim.api[k](...)
    end
  end,
})

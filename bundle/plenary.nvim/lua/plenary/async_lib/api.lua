local a = require "plenary.async_lib.async"
local async, await = a.async, a.await

return setmetatable({}, {
  __index = function(t, k)
    return async(function(...)
      -- if we are in a fast event await the scheduler
      if vim.in_fast_event() then
        await(a.scheduler())
      end

      vim.api[k](...)
    end)
  end,
})

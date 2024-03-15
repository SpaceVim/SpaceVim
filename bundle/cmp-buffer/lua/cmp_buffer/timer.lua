---This timer matches the semantics of setInterval and clearInterval of
---Javascript. It provides a more reliable alternative to vim.loop.timer_start
---with a callback wrapped into a vim.schedule call by addressing two problems:
---1. Scheduled callbacks are invoked less frequently than a libuv timer with a
---   small interval (1-5ms). This causes those callbacks to fill up the queue
---   in the event loop, and so the callback function may get invoked multiple
---   times on one event loop tick. In contrast, Javascript's setInterval
---   guarantees that the callback is not invoked more frequently than the
---   interval.
---2. When a libuv timer is stopped with vim.loop.timer_stop, it doesn't affect
---   the callbacks that have already been scheduled. So timer_stop will not
---   immediately stop the timer, the actual callback function will run one
---   more time until it is finally stopped. This implementation ensures that
---   timer_stop prevents any subsequent invocations of the callback.
---
---@class cmp_buffer.Timer
---@field public handle any
---@field private callback_wrapper_instance fun()|nil
local timer = {}

function timer.new()
  local self = setmetatable({}, { __index = timer })
  self.handle = vim.loop.new_timer()
  self.callback_wrapper_instance = nil
  return self
end

---@param timeout_ms number
---@param repeat_ms number
---@param callback fun()
function timer:start(timeout_ms, repeat_ms, callback)
  -- This is the flag that fixes problem 1.
  local scheduled = false
  -- Creating a function on every call to timer_start ensures that we can always
  -- detect when a different callback is set by calling timer_start and prevent
  -- the old one from being invoked.
  local function callback_wrapper()
    if scheduled then
      return
    end
    scheduled = true
    vim.schedule(function()
      scheduled = false
      -- Either a different callback was set, or the timer has been stopped.
      if self.callback_wrapper_instance ~= callback_wrapper then
        return
      end
      callback()
    end)
  end
  self.handle:start(timeout_ms, repeat_ms, callback_wrapper)
  self.callback_wrapper_instance = callback_wrapper
end

function timer:stop()
  self.handle:stop()
  self.callback_wrapper_instance = nil
end

function timer:is_active()
  return self.handle:is_active()
end

function timer:close()
  self.handle:close()
end

return timer

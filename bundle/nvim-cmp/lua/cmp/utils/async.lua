local async = {}

---@class cmp.AsyncThrottle
---@field public timeout number
---@field public stop function
---@field public __call function

---@param fn function
---@param timeout number
---@return cmp.AsyncThrottle
async.throttle = function(fn, timeout)
  local time = nil
  local timer = vim.loop.new_timer()
  return setmetatable({
    timeout = timeout,
    stop = function()
      time = nil
      timer:stop()
    end,
  }, {
    __call = function(self, ...)
      local args = { ... }

      if time == nil then
        time = vim.loop.now()
      end
      timer:stop()

      local delta = math.max(1, self.timeout - (vim.loop.now() - time))
      timer:start(delta, 0, function()
        time = nil
        fn(unpack(args))
      end)
    end,
  })
end

---Control async tasks.
async.step = function(...)
  local tasks = { ... }
  local next
  next = function(...)
    if #tasks > 0 then
      table.remove(tasks, 1)(next, ...)
    end
  end
  table.remove(tasks, 1)(next)
end

---Timeout callback function
---@param fn function
---@param timeout number
---@return function
async.timeout = function(fn, timeout)
  local timer
  local done = false
  local callback = function(...)
    if not done then
      done = true
      timer:stop()
      timer:close()
      fn(...)
    end
  end
  timer = vim.loop.new_timer()
  timer:start(timeout, 0, function()
    callback()
  end)
  return callback
end

---@alias cmp.AsyncDedup fun(callback: function): function

---Create deduplicated callback
---@return function
async.dedup = function()
  local id = 0
  return function(callback)
    id = id + 1

    local current = id
    return function(...)
      if current == id then
        callback(...)
      end
    end
  end
end

---Convert async process as sync
async.sync = function(runner, timeout)
  local done = false
  runner(function()
    done = true
  end)
  vim.wait(timeout, function()
    return done
  end, 10, false)
end

return async

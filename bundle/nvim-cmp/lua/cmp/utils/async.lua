local feedkeys = require('cmp.utils.feedkeys')
local config = require('cmp.config')

local async = {}

---@class cmp.AsyncThrottle
---@field public running boolean
---@field public timeout integer
---@field public sync function(self: cmp.AsyncThrottle, timeout: integer|nil)
---@field public stop function
---@field public __call function

---@type uv_timer_t[]
local timers = {}

vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    for _, timer in pairs(timers) do
      if timer and not timer:is_closing() then
        timer:stop()
        timer:close()
      end
    end
  end,
})

---@param fn function
---@param timeout integer
---@return cmp.AsyncThrottle
async.throttle = function(fn, timeout)
  local time = nil
  local timer = assert(vim.loop.new_timer())
  local _async = nil ---@type Async?
  timers[#timers + 1] = timer
  local throttle
  throttle = setmetatable({
    running = false,
    timeout = timeout,
    sync = function(self, timeout_)
      if not self.running then
        return
      end
      vim.wait(timeout_ or 1000, function()
        return not self.running
      end, 10)
    end,
    stop = function(reset_time)
      if reset_time ~= false then
        time = nil
      end
      -- can't use self here unfortunately
      throttle.running = false
      timer:stop()
      if _async then
        _async:cancel()
        _async = nil
      end
    end,
  }, {
    __call = function(self, ...)
      local args = { ... }

      if time == nil then
        time = vim.loop.now()
      end
      self.stop(false)
      self.running = true
      timer:start(math.max(1, self.timeout - (vim.loop.now() - time)), 0, function()
        vim.schedule(function()
          time = nil
          local ret = fn(unpack(args))
          if async.is_async(ret) then
            ---@cast ret Async
            _async = ret
            _async:await(function(_, error)
              _async = nil
              self.running = false
              if error and error ~= 'abort' then
                vim.notify(error, vim.log.levels.ERROR)
              end
            end)
          else
            self.running = false
          end
        end)
      end)
    end,
  })
  return throttle
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
---@param timeout integer
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

---Wait and callback for next safe state.
async.debounce_next_tick = function(callback)
  local running = false
  return function()
    if running then
      return
    end
    running = true
    vim.schedule(function()
      running = false
      callback()
    end)
  end
end

---Wait and callback for consuming next keymap.
async.debounce_next_tick_by_keymap = function(callback)
  return function()
    feedkeys.call('', '', callback)
  end
end

local Scheduler = {}
Scheduler._queue = {}
Scheduler._executor = assert(vim.loop.new_check())

function Scheduler.step()
  local budget = config.get().performance.async_budget * 1e6
  local start = vim.loop.hrtime()
  while #Scheduler._queue > 0 and vim.loop.hrtime() - start < budget do
    local a = table.remove(Scheduler._queue, 1)
    a:_step()
    if a.running then
      table.insert(Scheduler._queue, a)
    end
  end
  if #Scheduler._queue == 0 then
    return Scheduler._executor:stop()
  end
end

---@param a Async
function Scheduler.add(a)
  table.insert(Scheduler._queue, a)
  if not Scheduler._executor:is_active() then
    Scheduler._executor:start(vim.schedule_wrap(Scheduler.step))
  end
end

--- @alias AsyncCallback fun(result?:any, error?:string)

--- @class Async
--- @field running boolean
--- @field result? any
--- @field error? string
--- @field callbacks AsyncCallback[]
--- @field thread thread
local Async = {}
Async.__index = Async

function Async.new(fn)
  local self = setmetatable({}, Async)
  self.callbacks = {}
  self.running = true
  self.thread = coroutine.create(fn)
  Scheduler.add(self)
  return self
end

---@param result? any
---@param error? string
function Async:_done(result, error)
  if self.running then
    self.running = false
    self.result = result
    self.error = error
  end
  for _, callback in ipairs(self.callbacks) do
    callback(result, error)
  end
  -- only run each callback once.
  -- _done can possibly be called multiple times.
  -- so we need to clear callbacks after executing them.
  self.callbacks = {}
end

function Async:_step()
  local ok, res = coroutine.resume(self.thread)
  if not ok then
    return self:_done(nil, res)
  elseif res == 'abort' then
    return self:_done(nil, 'abort')
  elseif coroutine.status(self.thread) == 'dead' then
    return self:_done(res)
  end
end

function Async:cancel()
  self:_done(nil, 'abort')
end

---@param cb AsyncCallback
function Async:await(cb)
  if not cb then
    error('callback is required')
  end
  if self.running then
    table.insert(self.callbacks, cb)
  else
    cb(self.result, self.error)
  end
end

function Async:sync()
  while self.running do
    vim.wait(10)
  end
  return self.error and error(self.error) or self.result
end

--- @return boolean
function async.is_async(obj)
  return obj and type(obj) == 'table' and getmetatable(obj) == Async
end

--- @return fun(...): Async
function async.wrap(fn)
  return function(...)
    local args = { ... }
    return Async.new(function()
      return fn(unpack(args))
    end)
  end
end

-- This will yield when called from a coroutine
function async.yield(...)
  if coroutine.running() == nil then
    error('Trying to yield from a non-yieldable context')
    return ...
  end
  return coroutine.yield(...)
end

function async.abort()
  return async.yield('abort')
end

return async

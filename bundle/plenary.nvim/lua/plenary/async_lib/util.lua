local a = require "plenary.async_lib.async"
local await = a.await
local async = a.async
local co = coroutine
local Deque = require("plenary.async_lib.structs").Deque
local uv = vim.loop

local M = {}

---Sleep for milliseconds
---@param ms number
M.sleep = a.wrap(function(ms, callback)
  local timer = uv.new_timer()
  uv.timer_start(timer, ms, 0, function()
    uv.timer_stop(timer)
    uv.close(timer)
    callback()
  end)
end, 2)

---Takes a future and a millisecond as the timeout.
---If the time is reached and the future hasn't completed yet, it will short circuit the future
---NOTE: the future will still be running in libuv, we are just not waiting for it to complete
---thats why you should call this on a leaf future only to avoid unexpected results
---@param future Future
---@param ms number
M.timeout = a.wrap(function(future, ms, callback)
  -- make sure that the callback isn't called twice, or else the coroutine can be dead
  local done = false

  local timeout_callback = function(...)
    if not done then
      done = true
      callback(false, ...) -- false because it has run normally
    end
  end

  vim.defer_fn(function()
    if not done then
      done = true
      callback(true) -- true because it has timed out
    end
  end, ms)

  a.run(future, timeout_callback)
end, 3)

---create an async function timer
---@param ms number
M.timer = function(ms)
  return async(function()
    await(M.sleep(ms))
  end)
end

---id function that can be awaited
---@param nil ...
---@return ...
M.id = async(function(...)
  return ...
end)

---Running this function will yield now and do nothing else
M.yield_now = async(function()
  await(M.id())
end)

local Condvar = {}
Condvar.__index = Condvar

---@class Condvar
---@return Condvar
function Condvar.new()
  return setmetatable({ handles = {} }, Condvar)
end

---`blocks` the thread until a notification is received
Condvar.wait = a.wrap(function(self, callback)
  -- not calling the callback will block the coroutine
  table.insert(self.handles, callback)
end, 2)

---notify everyone that is waiting on this Condvar
function Condvar:notify_all()
  if #self.handles == 0 then
    return
  end

  for i, callback in ipairs(self.handles) do
    callback()
    self.handles[i] = nil
  end
end

---notify randomly one person that is waiting on this Condvar
function Condvar:notify_one()
  if #self.handles == 0 then
    return
  end

  local idx = math.random(#self.handles)
  self.handles[idx]()
  table.remove(self.handles, idx)
end

M.Condvar = Condvar

local Semaphore = {}
Semaphore.__index = Semaphore

---@class Semaphore
---@param initial_permits number: the number of permits that it can give out
---@return Semaphore
function Semaphore.new(initial_permits)
  vim.validate {
    initial_permits = {
      initial_permits,
      function(n)
        return n > 0
      end,
      "number greater than 0",
    },
  }

  return setmetatable({ permits = initial_permits, handles = {} }, Semaphore)
end

---async function, blocks until a permit can be acquired
---example:
---local semaphore = Semaphore.new(1024)
---local permit = await(semaphore:acquire())
---permit:forget()
---when a permit can be acquired returns it
---call permit:forget() to forget the permit
Semaphore.acquire = a.wrap(function(self, callback)
  if self.permits > 0 then
    self.permits = self.permits - 1
  else
    table.insert(self.handles, callback)
    return
  end

  local permit = {}

  permit.forget = function(self_permit)
    self.permits = self.permits + 1

    if self.permits > 0 and #self.handles > 0 then
      self.permits = self.permits - 1
      local callback = table.remove(self.handles)
      callback(self_permit)
    end
  end

  callback(permit)
end, 2)

M.Semaphore = Semaphore

M.channel = {}

---Creates a oneshot channel
---returns a sender and receiver function
---the sender is not async while the receiver is
---@return function, function
M.channel.oneshot = function()
  local val = nil
  local saved_callback = nil
  local sent = false
  local received = false

  --- sender is not async
  --- sends a value
  local sender = function(...)
    if sent then
      error "Oneshot channel can only send once"
    end

    sent = true

    local args = { ... }

    if saved_callback then
      saved_callback(unpack(val or args))
    else
      val = args
    end
  end

  --- receiver is async
  --- blocks until a value is received
  local receiver = a.wrap(function(callback)
    if received then
      error "Oneshot channel can only send one value!"
    end

    if val then
      received = true
      callback(unpack(val))
    else
      saved_callback = callback
    end
  end, 1)

  return sender, receiver
end

---A counter channel.
---Basically a channel that you want to use only to notify and not to send any actual values.
---@return function: sender
---@return function: receiver
M.channel.counter = function()
  local counter = 0
  local condvar = Condvar.new()

  local Sender = {}

  function Sender:send()
    counter = counter + 1
    condvar:notify_all()
  end

  local Receiver = {}

  Receiver.recv = async(function()
    if counter == 0 then
      await(condvar:wait())
    end
    counter = counter - 1
  end)

  Receiver.last = async(function()
    if counter == 0 then
      await(condvar:wait())
    end
    counter = 0
  end)

  return Sender, Receiver
end

---A multiple producer single consumer channel
---@return table
---@return table
M.channel.mpsc = function()
  local deque = Deque.new()
  local condvar = Condvar.new()

  local Sender = {}

  function Sender.send(...)
    deque:pushleft { ... }
    condvar:notify_all()
  end

  local Receiver = {}

  Receiver.recv = async(function()
    if deque:is_empty() then
      await(condvar:wait())
    end
    return unpack(deque:popright())
  end)

  Receiver.last = async(function()
    if deque:is_empty() then
      await(condvar:wait())
    end
    local val = deque:popright()
    deque:clear()
    return unpack(val)
  end)

  return Sender, Receiver
end

local pcall_wrap = function(func)
  return function(...)
    return pcall(func, ...)
  end
end

---Makes a future protected. It is like pcall but for futures.
---Only works for non-leaf futures
M.protected_non_leaf = async(function(future)
  return await(pcall_wrap(future))
end)

---Makes a future protected. It is like pcall but for futures.
---@param future Future
---@return Future
M.protected = async(function(future)
  local tx, rx = M.channel.oneshot()

  stat, ret = pcall(future, tx)

  if stat == true then
    return stat, await(rx())
  else
    return stat, ret
  end
end)

---This will COMPLETELY block neovim
---please just use a.run unless you have a very special usecase
---for example, in plenary test_harness you must use this
---@param future Future
---@param timeout number: Stop blocking if the timeout was surpassed. Default 2000.
M.block_on = function(future, timeout)
  future = M.protected(future)

  local stat, ret
  a.run(future, function(_stat, ...)
    stat = _stat
    ret = { ... }
  end)

  local function check()
    if stat == false then
      error("Blocking on future failed " .. unpack(ret))
    end
    return stat == true
  end

  if not vim.wait(timeout or 2000, check, 20, false) then
    error "Blocking on future timed out or was interrupted"
  end

  return unpack(ret)
end

---Returns a new future that WILL BLOCK
---@param future Future
---@return Future
M.will_block = async(function(future)
  return M.block_on(future)
end)

return M

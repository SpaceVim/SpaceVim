local a = require "plenary.async.async"
local Deque = require("plenary.async.structs").Deque
local tbl = require "plenary.tbl"

local M = {}

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
  local is_single = false

  --- sender is not async
  --- sends a value which can be nil
  local sender = function(...)
    assert(not sent, "Oneshot channel can only send once")
    sent = true

    if saved_callback ~= nil then
      saved_callback(...)
      return
    end

    -- optimise for when there is only one or zero argument, no need to pack
    local nargs = select("#", ...)
    if nargs == 1 or nargs == 0 then
      val = ...
      is_single = true
    else
      val = tbl.pack(...)
    end
  end

  --- receiver is async
  --- blocks until a value is received
  local receiver = a.wrap(function(callback)
    assert(not received, "Oneshot channel can only receive one value!")

    if sent then
      received = true
      if is_single then
        return callback(val)
      else
        return callback(tbl.unpack(val))
      end
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

  Receiver.recv = function()
    if counter == 0 then
      await(condvar:wait())
    end
    counter = counter - 1
  end

  Receiver.last = function()
    if counter == 0 then
      await(condvar:wait())
    end
    counter = 0
  end

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

  Receiver.recv = function()
    if deque:is_empty() then
      condvar:wait()
    end
    return unpack(deque:popright())
  end

  Receiver.last = function()
    if deque:is_empty() then
      condvar:wait()
    end
    local val = deque:popright()
    deque:clear()
    return unpack(val or {})
  end

  return Sender, Receiver
end

return M

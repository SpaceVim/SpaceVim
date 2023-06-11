---@class cmp_dictionary.kit.App.Event
---@field private _events table<string, table>
local Event = {}
Event.__index = Event

---Create new Event.
function Event.new()
  local self = setmetatable({}, Event)
  self._events = {}
  return self
end

---Register listener.
---@param name string
---@param listener function
---@return function
function Event:on(name, listener)
  self._events[name] = self._events[name] or {}
  table.insert(self._events[name], listener)
  return function()
    self:off(name, listener)
  end
end

---Register once listener.
---@param name string
---@param listener function
function Event:once(name, listener)
  local off
  off = self:on(name, function(...)
    listener(...)
    off()
  end)
end

---Off specified listener from event.
---@param name string
---@param listener function
function Event:off(name, listener)
  self._events[name] = self._events[name] or {}
  if not listener then
    self._events[name] = nil
  else
    for i = #self._events[name], 1, -1 do
      if self._events[name][i] == listener then
        table.remove(self._events[name], i)
        break
      end
    end
  end
end

---Return if the listener is registered.
---@param name string
---@param listener? function
---@return boolean
function Event:has(name, listener)
  self._events[name] = self._events[name] or {}
  for _, v in ipairs(self._events[name]) do
    if v == listener then
      return true
    end
  end
  return false
end

---Emit event.
---@param name string
---@vararg any
function Event:emit(name, ...)
  self._events[name] = self._events[name] or {}
  for _, v in ipairs(self._events[name]) do
    v(...)
  end
end

return Event

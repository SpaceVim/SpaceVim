---@class cmp.Cache
---@field public entries any
local cache = {}

cache.new = function()
  local self = setmetatable({}, { __index = cache })
  self.entries = {}
  return self
end

---Get cache value
---@param key string|string[]
---@return any|nil
cache.get = function(self, key)
  key = self:key(key)
  if self.entries[key] ~= nil then
    return self.entries[key]
  end
  return nil
end

---Set cache value explicitly
---@param key string|string[]
---@vararg any
cache.set = function(self, key, value)
  key = self:key(key)
  self.entries[key] = value
end

---Ensure value by callback
---@generic T
---@param key string|string[]
---@param callback fun(): T
---@return T
cache.ensure = function(self, key, callback)
  local value = self:get(key)
  if value == nil then
    local v = callback()
    self:set(key, v)
    return v
  end
  return value
end

---Clear all cache entries
cache.clear = function(self)
  self.entries = {}
end

---Create key
---@param key string|string[]
---@return string
cache.key = function(_, key)
  if type(key) == 'table' then
    return table.concat(key, ':')
  end
  return key
end

return cache

---Create cache key.
---@private
---@param key string[]|string
---@return string
local function _key(key)
  if type(key) == 'table' then
    return table.concat(key, ':')
  end
  return key
end

---@class cmp_dictionary.kit.App.Cache
---@field private keys table<string, boolean>
---@field private entries table<string, any>
local Cache = {}
Cache.__index = Cache

---Create new cache instance.
function Cache.new()
  local self = setmetatable({}, Cache)
  self.keys = {}
  self.entries = {}
  return self
end

---Get cache entry.
---@param key string[]|string
---@return any
function Cache:get(key)
  return self.entries[_key(key)]
end

---Set cache entry.
---@param key string[]|string
---@param val any
function Cache:set(key, val)
  key = _key(key)
  self.keys[key] = true
  self.entries[key] = val
end

---Delete cache entry.
---@param key string[]|string
function Cache:del(key)
  key = _key(key)
  self.keys[key] = nil
  self.entries[key] = nil
end

---Return this cache has the key entry or not.
---@param key string[]|string
---@return boolean
function Cache:has(key)
  key = _key(key)
  return not not self.keys[key]
end

---Ensure cache entry.
---@generic T
---@param key string[]|string
---@param callback function(): T
---@return T
function Cache:ensure(key, callback)
  if not self:has(key) then
    self:set(key, callback())
  end
  return self:get(key)
end

return Cache

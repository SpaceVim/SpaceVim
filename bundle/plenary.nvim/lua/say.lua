local unpack = table.unpack or unpack

local registry = { }
local current_namespace
local fallback_namespace

local s = {

  _COPYRIGHT   = "Copyright (c) 2012 Olivine Labs, LLC.",
  _DESCRIPTION = "A simple string key/value store for i18n or any other case where you want namespaced strings.",
  _VERSION     = "Say 1.2",

  set_namespace = function(self, namespace)
    current_namespace = namespace
    if not registry[current_namespace] then
      registry[current_namespace] = {}
    end
  end,

  set_fallback = function(self, namespace)
    fallback_namespace = namespace
    if not registry[fallback_namespace] then
      registry[fallback_namespace] = {}
    end
  end,

  set = function(self, key, value)
    registry[current_namespace][key] = value
  end
}

local __meta = {
  __call = function(self, key, vars)
    vars = vars or {}

    local str = registry[current_namespace][key] or registry[fallback_namespace][key]

    if str == nil then
      return nil
    end
    str = tostring(str)
    local strings = {}

    for i,v in ipairs(vars) do
      table.insert(strings, tostring(v))
    end

    return #strings > 0 and str:format(unpack(strings)) or str
  end,

  __index = function(self, key)
    return registry[key]
  end
}

s:set_fallback('en')
s:set_namespace('en')

s._registry = registry

return setmetatable(s, __meta)

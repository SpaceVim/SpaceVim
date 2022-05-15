local namespace = require 'luassert.namespaces'
local util = require 'luassert.util'

local matcher_mt = {
  __call = function(self, value)
    return self.callback(value) == self.mod
  end,
}

local state_mt = {
  __call = function(self, ...)
    local keys = util.extract_keys("matcher", self.tokens)
    self.tokens = {}

    local matcher

    for _, key in ipairs(keys) do
      matcher = namespace.matcher[key] or matcher
    end

    if matcher then
      for _, key in ipairs(keys) do
        if namespace.modifier[key] then
          namespace.modifier[key].callback(self)
        end
      end

      local arguments = {...}
      arguments.n = select('#', ...) -- add argument count for trailing nils
      local matches = matcher.callback(self, arguments, util.errorlevel())
      return setmetatable({
        name = matcher.name,
        mod = self.mod,
        callback = matches,
      }, matcher_mt)
    else
      local arguments = {...}
      arguments.n = select('#', ...) -- add argument count for trailing nils

      for _, key in ipairs(keys) do
        if namespace.modifier[key] then
          namespace.modifier[key].callback(self, arguments, util.errorlevel())
        end
      end
    end

    return self
  end,

  __index = function(self, key)
    for token in key:lower():gmatch('[^_]+') do
      table.insert(self.tokens, token)
    end

    return self
  end
}

local match = {
  _ = setmetatable({mod=true, callback=function() return true end}, matcher_mt),

  state = function() return setmetatable({mod=true, tokens={}}, state_mt) end,

  is_matcher = function(object)
    return type(object) == "table" and getmetatable(object) == matcher_mt
  end,

  is_ref_matcher = function(object)
    local ismatcher = (type(object) == "table" and getmetatable(object) == matcher_mt)
    return ismatcher and object.name == "ref"
  end,
}

local mt = {
  __index = function(self, key)
    return rawget(self, key) or self.state()[key]
  end,
}

return setmetatable(match, mt)

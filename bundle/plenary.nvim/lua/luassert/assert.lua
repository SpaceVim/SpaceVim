local s = require 'say'
local astate = require 'luassert.state'
local util = require 'luassert.util'
local unpack = require 'luassert.compatibility'.unpack
local obj   -- the returned module table
local level_mt = {}

-- list of namespaces
local namespace = require 'luassert.namespaces'

local function geterror(assertion_message, failure_message, args)
  if util.hastostring(failure_message) then
    failure_message = tostring(failure_message)
  elseif failure_message ~= nil then
    failure_message = astate.format_argument(failure_message)
  end
  local message = s(assertion_message, obj:format(args))
  if message and failure_message then
    message = failure_message .. "\n" .. message
  end
  return message or failure_message
end

local __state_meta = {

  __call = function(self, ...)
    local keys = util.extract_keys("assertion", self.tokens)

    local assertion

    for _, key in ipairs(keys) do
      assertion = namespace.assertion[key] or assertion
    end

    if assertion then
      for _, key in ipairs(keys) do
        if namespace.modifier[key] then
          namespace.modifier[key].callback(self)
        end
      end

      local arguments = {...}
      arguments.n = select('#', ...) -- add argument count for trailing nils
      local val, retargs = assertion.callback(self, arguments, util.errorlevel())

      if not val == self.mod then
        local message = assertion.positive_message
        if not self.mod then
          message = assertion.negative_message
        end
        local err = geterror(message, rawget(self,"failure_message"), arguments)
        error(err or "assertion failed!", util.errorlevel())
      end

      if retargs then
        return unpack(retargs)
      end
      return ...
    else
      local arguments = {...}
      arguments.n = select('#', ...)
      self.tokens = {}

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

obj = {
  state = function() return setmetatable({mod=true, tokens={}}, __state_meta) end,

  -- registers a function in namespace
  register = function(self, nspace, name, callback, positive_message, negative_message)
    local lowername = name:lower()
    if not namespace[nspace] then
      namespace[nspace] = {}
    end
    namespace[nspace][lowername] = {
      callback = callback,
      name = lowername,
      positive_message=positive_message,
      negative_message=negative_message
    }
  end,

  -- unregisters a function in a namespace
  unregister = function(self, nspace, name)
    local lowername = name:lower()
    if not namespace[nspace] then
      namespace[nspace] = {}
    end
    namespace[nspace][lowername] = nil
  end,

  -- registers a formatter
  -- a formatter takes a single argument, and converts it to a string, or returns nil if it cannot format the argument
  add_formatter = function(self, callback)
    astate.add_formatter(callback)
  end,

  -- unregisters a formatter
  remove_formatter = function(self, fmtr)
    astate.remove_formatter(fmtr)
  end,

  format = function(self, args)
    -- args.n specifies the number of arguments in case of 'trailing nil' arguments which get lost
    local nofmt = args.nofmt or {}  -- arguments in this list should not be formatted
    local fmtargs = args.fmtargs or {} -- additional arguments to be passed to formatter
    for i = 1, (args.n or #args) do -- cannot use pairs because table might have nils
      if not nofmt[i] then
        local val = args[i]
        local valfmt = astate.format_argument(val, nil, fmtargs[i])
        if valfmt == nil then valfmt = tostring(val) end -- no formatter found
        args[i] = valfmt
      end
    end
    return args
  end,

  set_parameter = function(self, name, value)
    astate.set_parameter(name, value)
  end,
  
  get_parameter = function(self, name)
    return astate.get_parameter(name)
  end,  
  
  add_spy = function(self, spy)
    astate.add_spy(spy)
  end,
  
  snapshot = function(self)
    return astate.snapshot()
  end,
  
  level = function(self, level)
    return setmetatable({
        level = level
      }, level_mt)
  end,
  
  -- returns the level if a level-value, otherwise nil
  get_level = function(self, level)
    if getmetatable(level) ~= level_mt then
      return nil -- not a valid error-level
    end
    return level.level
  end,
}

local __meta = {

  __call = function(self, bool, message, level, ...)
    if not bool then
      local err_level = (self:get_level(level) or 1) + 1
      error(message or "assertion failed!", err_level)
    end
    return bool , message , level , ...
  end,

  __index = function(self, key)
    return rawget(self, key) or self.state()[key]
  end,

}

return setmetatable(obj, __meta)

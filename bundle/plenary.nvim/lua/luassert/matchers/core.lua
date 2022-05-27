-- module will return the list of matchers, and registers matchers with the main assert engine

-- matchers take 1 parameters;
-- 1) state
-- 2) arguments list. The list has a member 'n' with the argument count to check for trailing nils
-- 3) level The level of the error position relative to the called function
-- returns; function (or callable object); a function that, given an argument, returns a boolean

local assert = require('luassert.assert')
local astate = require('luassert.state')
local util = require('luassert.util')
local s = require('say')

local function format(val)
  return astate.format_argument(val) or tostring(val)
end

local function unique(state, arguments, level)
  local deep = arguments[1]
  return function(value)
    local list = value
    for k,v in pairs(list) do
      for k2, v2 in pairs(list) do
        if k ~= k2 then
          if deep and util.deepcompare(v, v2, true) then
            return false
          else
            if v == v2 then
              return false
            end
          end
        end
      end
    end
    return true
  end
end

local function near(state, arguments, level)
  local level = (level or 1) + 1
  local argcnt = arguments.n
  assert(argcnt > 1, s("assertion.internal.argtolittle", { "near", 2, tostring(argcnt) }), level)
  local expected = tonumber(arguments[1])
  local tolerance = tonumber(arguments[2])
  local numbertype = "number or object convertible to a number"
  assert(expected, s("assertion.internal.badargtype", { 1, "near", numbertype, format(arguments[1]) }), level)
  assert(tolerance, s("assertion.internal.badargtype", { 2, "near", numbertype, format(arguments[2]) }), level)

  return function(value)
    local actual = tonumber(value)
    if not actual then return false end
    return (actual >= expected - tolerance and actual <= expected + tolerance)
  end
end

local function matches(state, arguments, level)
  local level = (level or 1) + 1
  local argcnt = arguments.n
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "matches", 1, tostring(argcnt) }), level)
  local pattern = arguments[1]
  local init = arguments[2]
  local plain = arguments[3]
  local stringtype = "string or object convertible to a string"
  assert(type(pattern) == "string", s("assertion.internal.badargtype", { 1, "matches", "string", type(arguments[1]) }), level)
  assert(init == nil or tonumber(init), s("assertion.internal.badargtype", { 2, "matches", "number", type(arguments[2]) }), level)

  return function(value)
    local actualtype = type(value)
    local actual = nil
    if actualtype == "string" or actualtype == "number" or
      actualtype == "table" and (getmetatable(value) or {}).__tostring then
      actual = tostring(value)
    end
    if not actual then return false end
    return (actual:find(pattern, init, plain) ~= nil)
  end
end

local function equals(state, arguments, level)
  local level = (level or 1) + 1
  local argcnt = arguments.n
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "equals", 1, tostring(argcnt) }), level)
  return function(value)
    return value == arguments[1]
  end
end

local function same(state, arguments, level)
  local level = (level or 1) + 1
  local argcnt = arguments.n
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "same", 1, tostring(argcnt) }), level)
  return function(value)
    if type(value) == 'table' and type(arguments[1]) == 'table' then
      local result = util.deepcompare(value, arguments[1], true)
      return result
    end
    return value == arguments[1]
  end
end

local function ref(state, arguments, level)
  local level = (level or 1) + 1
  local argcnt = arguments.n
  local argtype = type(arguments[1])
  local isobject = (argtype == "table" or argtype == "function" or argtype == "thread" or argtype == "userdata")
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "ref", 1, tostring(argcnt) }), level)
  assert(isobject, s("assertion.internal.badargtype", { 1, "ref", "object", argtype }), level)
  return function(value)
    return value == arguments[1]
  end
end

local function is_true(state, arguments, level)
  return function(value)
    return value == true
  end
end

local function is_false(state, arguments, level)
  return function(value)
    return value == false
  end
end

local function truthy(state, arguments, level)
  return function(value)
    return value ~= false and value ~= nil
  end
end

local function falsy(state, arguments, level)
  local is_truthy = truthy(state, arguments, level)
  return function(value)
    return not is_truthy(value)
  end
end

local function is_type(state, arguments, level, etype)
  return function(value)
    return type(value) == etype
  end
end

local function is_nil(state, arguments, level)      return is_type(state, arguments, level, "nil")      end
local function is_boolean(state, arguments, level)  return is_type(state, arguments, level, "boolean")  end
local function is_number(state, arguments, level)   return is_type(state, arguments, level, "number")   end
local function is_string(state, arguments, level)   return is_type(state, arguments, level, "string")   end
local function is_table(state, arguments, level)    return is_type(state, arguments, level, "table")    end
local function is_function(state, arguments, level) return is_type(state, arguments, level, "function") end
local function is_userdata(state, arguments, level) return is_type(state, arguments, level, "userdata") end
local function is_thread(state, arguments, level)   return is_type(state, arguments, level, "thread")   end

assert:register("matcher", "true", is_true)
assert:register("matcher", "false", is_false)

assert:register("matcher", "nil", is_nil)
assert:register("matcher", "boolean", is_boolean)
assert:register("matcher", "number", is_number)
assert:register("matcher", "string", is_string)
assert:register("matcher", "table", is_table)
assert:register("matcher", "function", is_function)
assert:register("matcher", "userdata", is_userdata)
assert:register("matcher", "thread", is_thread)

assert:register("matcher", "ref", ref)
assert:register("matcher", "same", same)
assert:register("matcher", "matches", matches)
assert:register("matcher", "match", matches)
assert:register("matcher", "near", near)
assert:register("matcher", "equals", equals)
assert:register("matcher", "equal", equals)
assert:register("matcher", "unique", unique)
assert:register("matcher", "truthy", truthy)
assert:register("matcher", "falsy", falsy)

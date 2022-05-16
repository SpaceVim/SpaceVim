---@brief [[
---An adaptation of luafun for neovim.
---This library will use neovim specific functions.
---Some documentation is the same as from luafun.
---Some extra functions are present that are not in luafun
---@brief ]]

local co = coroutine
local f = require "plenary.functional"

--------------------------------------------------------------------------------
-- Tools
--------------------------------------------------------------------------------

local exports = {}

---@class Iterator
---@field gen function
---@field param any
---@field state any
local Iterator = {}
Iterator.__index = Iterator

---Makes a for loop work
---If not called without param or state, will just generate with the starting state
---This is useful because the original luafun will also return param and state in addition to the iterator as a multival
---This can cause problems because when using iterators as expressions the multivals can bleed
---For example i.iter { 1, 2, i.iter { 3, 4 } } will not work because the inner iterator returns a multival thus polluting the list with internal values
---So instead we do not return param and state as multivals when doing wrap
---This causes the first loop iteration to call param and state with nil because we didn't return them as multivals
---We have to use or to check for nil and default to interal starting state and param
function Iterator:__call(param, state)
  return self.gen(param or self.param, state or self.state)
end

function Iterator:__tostring()
  return "<iterator>"
end

-- A special hack for zip/chain to skip last two state, if a wrapped iterator
-- has been passed
local numargs = function(...)
  local n = select("#", ...)
  if n >= 3 then
    -- Fix last argument
    local it = select(n - 2, ...)
    if
      type(it) == "table"
      and getmetatable(it) == Iterator
      and it.param == select(n - 1, ...)
      and it.state == select(n, ...)
    then
      return n - 2
    end
  end
  return n
end

local return_if_not_empty = function(state_x, ...)
  if state_x == nil then
    return nil
  end
  return ...
end

local call_if_not_empty = function(fun, state_x, ...)
  if state_x == nil then
    return nil
  end
  return state_x, fun(...)
end

--------------------------------------------------------------------------------
-- Basic Functions
--------------------------------------------------------------------------------
local nil_gen = function(_param, _state)
  return nil
end

local ipairs_gen = ipairs {}

local pairs_gen = pairs {}

local map_gen = function(map, key)
  key, value = pairs_gen(map, key)
  return key, key, value
end

local string_gen = function(param, state)
  state = state + 1
  if state > #param then
    return nil
  end
  local r = string.sub(param, state, state)
  return state, r
end

local rawiter = function(obj, param, state)
  assert(obj ~= nil, "invalid iterator")

  if type(obj) == "table" then
    local mt = getmetatable(obj)

    if mt ~= nil then
      if mt == Iterator then
        return obj.gen, obj.param, obj.state
      end
    end

    if vim.tbl_islist(obj) then
      return ipairs(obj)
    else
      -- hash
      return map_gen, obj, nil
    end
  elseif type(obj) == "function" then
    return obj, param, state
  elseif type(obj) == "string" then
    if #obj == 0 then
      return nil_gen, nil, nil
    end

    return string_gen, obj, 0
  end

  error(string.format('object %s of type "%s" is not iterable', obj, type(obj)))
end

---Wraps the iterator triplet into a table to allow metamethods and calling with method form
---Important! We do not return param and state as multivals like the original luafun
---Se the __call metamethod for more information
---@param gen any
---@param param any
---@param state any
---@return Iterator
local function wrap(gen, param, state)
  return setmetatable({
    gen = gen,
    param = param,
    state = state,
  }, Iterator)
end

---Unwrap an iterator metatable into the iterator triplet
---@param self Iterator
---@return any
---@return any
---@return any
local unwrap = function(self)
  return self.gen, self.param, self.state
end

---Create an iterator from an object
---@param obj any
---@param param any (optional)
---@param state any (optional)
---@return Iterator
local iter = function(obj, param, state)
  return wrap(rawiter(obj, param, state))
end

exports.iter = iter
exports.wrap = wrap
exports.unwrap = unwrap

function Iterator:for_each(fn)
  local param, state = self.param, self.state
  repeat
    state = call_if_not_empty(fn, self.gen(param, state))
  until state == nil
end

function Iterator:stateful()
  return wrap(
    co.wrap(function()
      self:for_each(function(...)
        co.yield(f.first(...), ...)
      end)

      -- too make sure that we always return nil if there are no more
      while true do
        co.yield()
      end
    end),
    nil,
    nil
  )
end

-- function Iterator:stateful()
--   local gen, param, state = self.gen, self.param, self.state

--   local function return_and_set_state(state_x, ...)
--     state = state_x
--     if state == nil then return end
--     return state_x, ...
--   end

--   local stateful_gen = function()
--     return return_and_set_state(gen(param, state))
--   end

--   return wrap(stateful_gen, false, false)
-- end

--------------------------------------------------------------------------------
-- Generators
--------------------------------------------------------------------------------
local range_gen = function(param, state)
  local stop, step = param[1], param[2]
  state = state + step
  if state > stop then
    return nil
  end
  return state, state
end

local range_rev_gen = function(param, state)
  local stop, step = param[1], param[2]
  state = state + step
  if state < stop then
    return nil
  end
  return state, state
end

---Creates a range iterator
---@param start number
---@param stop number
---@param step number
---@return Iterator
local range = function(start, stop, step)
  if step == nil then
    if stop == nil then
      if start == 0 then
        return nil_gen, nil, nil
      end
      stop = start
      start = stop > 0 and 1 or -1
    end
    step = start <= stop and 1 or -1
  end

  assert(type(start) == "number", "start must be a number")
  assert(type(stop) == "number", "stop must be a number")
  assert(type(step) == "number", "step must be a number")
  assert(step ~= 0, "step must not be zero")

  if step > 0 then
    return wrap(range_gen, { stop, step }, start - step)
  elseif step < 0 then
    return wrap(range_rev_gen, { stop, step }, start - step)
  end
end
exports.range = range

local duplicate_table_gen = function(param_x, state_x)
  return state_x + 1, unpack(param_x)
end

local duplicate_fun_gen = function(param_x, state_x)
  return state_x + 1, param_x(state_x)
end

local duplicate_gen = function(param_x, state_x)
  return state_x + 1, param_x
end

---Creates an infinite iterator that will yield the arguments
---If multiple arguments are passed, the args will be packed and unpacked
---@param ...: the arguments to duplicate
---@return Iterator
local duplicate = function(...)
  if select("#", ...) <= 1 then
    return wrap(duplicate_gen, select(1, ...), 0)
  else
    return wrap(duplicate_table_gen, { ... }, 0)
  end
end
exports.duplicate = duplicate

---Creates an iterator from a function
---NOTE: if the function is a closure and modifies state, the resulting iterator will not be stateless
---@param fun function
---@return Iterator
local from_fun = function(fun)
  assert(type(fun) == "function")
  return wrap(duplicate_fun_gen, fun, 0)
end
exports.from_fun = from_fun

---Creates an infinite iterator that will yield zeros.
---This is an alias to calling duplicate(0)
---@return Iterator
local zeros = function()
  return wrap(duplicate_gen, 0, 0)
end
exports.zeros = zeros

---Creates an infinite iterator that will yield ones.
---This is an alias to calling duplicate(1)
---@return Iterator
local ones = function()
  return wrap(duplicate_gen, 1, 0)
end
exports.ones = ones

local rands_gen = function(param_x, _state_x)
  return 0, math.random(param_x[1], param_x[2])
end

local rands_nil_gen = function(_param_x, _state_x)
  return 0, math.random()
end

---Creates an infinite iterator that will yield random values.
---@param n number
---@param m number
---@return Iterator
local rands = function(n, m)
  if n == nil and m == nil then
    return wrap(rands_nil_gen, 0, 0)
  end
  assert(type(n) == "number", "invalid first arg to rands")
  if m == nil then
    m = n
    n = 0
  else
    assert(type(m) == "number", "invalid second arg to rands")
  end
  assert(n < m, "empty interval")
  return wrap(rands_gen, { n, m - 1 }, 0)
end
exports.rands = rands

local split_gen = function(param, state)
  local input, sep = param[1], param[2]
  local input_len = #input

  if state > input_len + 1 then
    return
  end

  local start, finish = string.find(input, sep, state, true)
  if not start then
    start = input_len + 1
    finish = input_len + 1
  end

  local sub_str = input:sub(state, start - 1)

  return finish + 1, sub_str
end

---Return an iterator of substrings separated by a string
---@param input string: the string to split
---@param sep string: the separator to find and split based on
---@return Iterator
local split = function(input, sep)
  return wrap(split_gen, { input, sep }, 1)
end
exports.split = split

---Splits a string based on a single space
---An alias for split(input, " ")
---@param input any
---@return any
local words = function(input)
  return split(input, " ")
end
exports.words = words

local lines = function(input)
  -- TODO: platform specific linebreaks
  return split(input, "\n")
end
exports.lines = lines

--------------------------------------------------------------------------------
-- Transformations
--------------------------------------------------------------------------------
local map_gen = function(param, state)
  local gen_x, param_x, fun = param[1], param[2], param[3]
  return call_if_not_empty(fun, gen_x(param_x, state))
end

---Iterator adapter that maps the previous iterator with a function
---@param fun function: The function to map with. Will be called on each element
---@return Iterator
function Iterator:map(fun)
  return wrap(map_gen, { self.gen, self.param, fun }, self.state)
end

local flatten_gen1
do
  local it = function(new_iter, state_x, ...)
    if state_x == nil then
      return nil
    end
    return { new_iter.gen, new_iter.param, state_x }, ...
  end

  flatten_gen1 = function(state, state_x, ...)
    if state_x == nil then
      return nil
    end

    local first_arg = f.first(...)

    -- experimental part
    if getmetatable(first_arg) == Iterator then
      -- attach the iterator to the rest
      local new_iter = (first_arg .. wrap(state[1], state[2], state_x)):flatten()
      -- advance the iterator by one
      return it(new_iter, new_iter.gen(new_iter.param, new_iter.state))
    end

    return { state[1], state[2], state_x }, ...
  end
end

local flatten_gen = function(_, state)
  if state == nil then
    return
  end
  local gen_x, param_x, state_x = state[1], state[2], state[3]
  return flatten_gen1(state, gen_x(param_x, state_x))
end

---Iterator adapter that will recursivley flatten nested iterator structure
---@return Iterator
function Iterator:flatten()
  return wrap(flatten_gen, false, { self.gen, self.param, self.state })
end

--------------------------------------------------------------------------------
-- Filtering
--------------------------------------------------------------------------------
local filter1_gen = function(fun, gen_x, param_x, state_x, a)
  while true do
    if state_x == nil or fun(a) then
      break
    end
    state_x, a = gen_x(param_x, state_x)
  end
  return state_x, a
end

-- call each other
-- because we can't assign a vararg mutably in a while loop like filter1_gen
-- so we have to use recursion in calling both of these functions
local filterm_gen
local filterm_gen_shrink = function(fun, gen_x, param_x, state_x)
  return filterm_gen(fun, gen_x, param_x, gen_x(param_x, state_x))
end

filterm_gen = function(fun, gen_x, param_x, state_x, ...)
  if state_x == nil then
    return nil
  end

  if fun(...) then
    return state_x, ...
  end

  return filterm_gen_shrink(fun, gen_x, param_x, state_x)
end

local filter_detect = function(fun, gen_x, param_x, state_x, ...)
  if select("#", ...) < 2 then
    return filter1_gen(fun, gen_x, param_x, state_x, ...)
  else
    return filterm_gen(fun, gen_x, param_x, state_x, ...)
  end
end

local filter_gen = function(param, state_x)
  local gen_x, param_x, fun = param[1], param[2], param[3]
  return filter_detect(fun, gen_x, param_x, gen_x(param_x, state_x))
end

---Iterator adapter that will filter values
---@param fun function: The function to filter values with. If the function returns true, the value will be kept.
---@return Iterator
function Iterator:filter(fun)
  return wrap(filter_gen, { self.gen, self.param, fun }, self.state)
end

--------------------------------------------------------------------------------
-- Reducing
--------------------------------------------------------------------------------

---Returns true if any of the values in the iterator satisfy a predicate
---@param fun function
---@return boolean
function Iterator:any(fun)
  local r
  local state, param, gen = self.state, self.param, self.gen
  repeat
    state, r = call_if_not_empty(fun, gen(param, state))
  until state == nil or r
  return r
end

---Returns true if all of the values in the iterator satisfy a predicate
---@param fun function
---@return boolean
function Iterator:all(fun)
  local r
  local state, param, gen = self.state, self.param, self.gen
  repeat
    state, r = call_if_not_empty(fun, gen(param, state))
  until state == nil or not r
  return state == nil
end

---Finds a value that is equal to the provided value of satisfies a predicate.
---@param val_or_fn any
---@return any
function Iterator:find(val_or_fn)
  local gen, param, state = self.gen, self.param, self.state
  if type(val_or_fn) == "function" then
    return return_if_not_empty(filter_detect(val_or_fn, gen, param, gen(param, state)))
  else
    for _, r in gen, param, state do
      if r == val_or_fn then
        return r
      end
    end
    return nil
  end
end

---Turns an iterator into a list.
---If the iterator yields multivals only the first multival will be used.
---@return table
function Iterator:tolist()
  local list = {}
  self:for_each(function(a)
    table.insert(list, a)
  end)
  return list
end

---Turns an iterator into a list.
---If the iterator yields multivals all multivals will be used and packed into a table.
---@return table
function Iterator:tolistn()
  local list = {}
  self:for_each(function(...)
    table.insert(list, { ... })
  end)
  return list
end

---Turns an iterator into a map.
---The first multival that the iterator yields will be the key.
---The second multival that the iterator yields will be the value.
---@return table
function Iterator:tomap()
  local map = {}
  self:for_each(function(key, value)
    map[key] = value
  end)
  return map
end

--------------------------------------------------------------------------------
-- Compositions
--------------------------------------------------------------------------------
-- call each other
local chain_gen_r1
local chain_gen_r2 = function(param, state, state_x, ...)
  if state_x == nil then
    local i = state[1] + 1
    if param[3 * i - 1] == nil then
      return nil
    end
    state_x = param[3 * i]
    return chain_gen_r1(param, { i, state_x })
  end
  return { state[1], state_x }, ...
end

chain_gen_r1 = function(param, state)
  local i, state_x = state[1], state[2]
  local gen_x, param_x = param[3 * i - 2], param[3 * i - 1]
  return chain_gen_r2(param, state, gen_x(param_x, state_x))
end

---Make an iterator that returns elements from the first iterator until it is exhausted, then proceeds to the next iterator,
---until all of the iterators are exhausted.
---Used for treating consecutive iterators as a single iterator.
---Infinity iterators are supported, but are not recommended.
---@param ...: the iterators to chain
---@return Iterator
local chain = function(...)
  local n = numargs(...)

  if n == 0 then
    return wrap(nil_gen, nil, nil)
  end

  local param = { [3 * n] = 0 }

  local i, gen_x, param_x, state_x
  for i = 1, n, 1 do
    local elem = select(i, ...)
    gen_x, param_x, state_x = unwrap(elem)
    param[3 * i - 2] = gen_x
    param[3 * i - 1] = param_x
    param[3 * i] = state_x
  end

  return wrap(chain_gen_r1, param, { 1, param[3] })
end

Iterator.chain = chain
Iterator.__concat = chain
exports.chain = chain

local function zip_gen_r(param, state, state_new, ...)
  if #state_new == #param / 2 then
    return state_new, ...
  end

  local i = #state_new + 1
  local gen_x, param_x = param[2 * i - 1], param[2 * i]
  local state_x, r = gen_x(param_x, state[i])
  if state_x == nil then
    return nil
  end
  table.insert(state_new, state_x)
  return zip_gen_r(param, state, state_new, r, ...)
end

local zip_gen = function(param, state)
  return zip_gen_r(param, state, {})
end

---Return a new iterator where i-th return value contains the i-th element from each of the iterators.
---The returned iterator is truncated in length to the length of the shortest iterator.
---For multi-return iterators only the first variable is used.
---@param ...: the iterators to zip
---@return Iterator
local zip = function(...)
  local n = numargs(...)
  if n == 0 then
    return wrap(nil_gen, nil, nil)
  end
  local param = { [2 * n] = 0 }
  local state = { [n] = 0 }

  local i, gen_x, param_x, state_x
  for i = 1, n, 1 do
    local it = select(n - i + 1, ...)
    gen_x, param_x, state_x = rawiter(it)
    param[2 * i - 1] = gen_x
    param[2 * i] = param_x
    state[i] = state_x
  end

  return wrap(zip_gen, param, state)
end

Iterator.zip = zip
Iterator.__div = zip
exports.zip = zip

return exports

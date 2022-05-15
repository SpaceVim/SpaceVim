local co = coroutine
local vararg = require "plenary.vararg"
local errors = require "plenary.errors"
local traceback_error = errors.traceback_error
local f = require "plenary.functional"

local M = {}

---because we can't store varargs
local function callback_or_next(step, thread, callback, ...)
  local stat = f.first(...)

  if not stat then
    error(string.format("The coroutine failed with this message: %s", f.second(...)))
  end

  if co.status(thread) == "dead" then
    if callback == nil then
      return
    end
    callback(select(2, ...))
  else
    local returned_function = f.second(...)
    local nargs = f.third(...)
    assert(type(returned_function) == "function", "type error :: expected func")
    returned_function(vararg.rotate(nargs, step, select(4, ...)))
  end
end

---Executes a future with a callback when it is done
---@param async_function Future: the future to execute
---@param callback function: the callback to call when done
local execute = function(async_function, callback, ...)
  assert(type(async_function) == "function", "type error :: expected func")

  local thread = co.create(async_function)

  local step
  step = function(...)
    callback_or_next(step, thread, callback, co.resume(thread, ...))
  end

  step(...)
end

local add_leaf_function
do
  ---A table to store all leaf async functions
  _PlenaryLeafTable = setmetatable({}, {
    __mode = "k",
  })

  add_leaf_function = function(async_func, argc)
    assert(_PlenaryLeafTable[async_func] == nil, "Async function should not already be in the table")
    _PlenaryLeafTable[async_func] = argc
  end

  function M.is_leaf_function(async_func)
    return _PlenaryLeafTable[async_func] ~= nil
  end

  function M.get_leaf_function_argc(async_func)
    return _PlenaryLeafTable[async_func]
  end
end

---Creates an async function with a callback style function.
---@param func function: A callback style function to be converted. The last argument must be the callback.
---@param argc number: The number of arguments of func. Must be included.
---@return function: Returns an async function
M.wrap = function(func, argc)
  if type(func) ~= "function" then
    traceback_error("type error :: expected func, got " .. type(func))
  end

  if type(argc) ~= "number" then
    traceback_error("type error :: expected number, got " .. type(argc))
  end

  local function leaf(...)
    local nargs = select("#", ...)

    if nargs == argc then
      return func(...)
    else
      return co.yield(func, argc, ...)
    end
  end

  add_leaf_function(leaf, argc)

  return leaf
end

---Use this to either run a future concurrently and then do something else
---or use it to run a future with a callback in a non async context
---@param async_function function
---@param callback function
M.run = function(async_function, callback)
  if M.is_leaf_function(async_function) then
    async_function(callback)
  else
    execute(async_function, callback)
  end
end

---Use this to create a function which executes in an async context but
---called from a non-async context. Inherently this cannot return anything
---since it is non-blocking
---@param func function
M.void = function(func)
  return function(...)
    execute(func, nil, ...)
  end
end

return M

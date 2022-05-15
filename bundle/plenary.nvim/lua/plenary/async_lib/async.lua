local co = coroutine
local errors = require "plenary.errors"
local traceback_error = errors.traceback_error
local f = require "plenary.functional"
local tbl = require "plenary.tbl"

local M = {}

---because we can't store varargs
local function callback_or_next(step, thread, callback, ...)
  local stat = f.first(...)

  if not stat then
    error(string.format("The coroutine failed with this message: %s", f.second(...)))
  end

  if co.status(thread) == "dead" then
    (callback or function() end)(select(2, ...))
  else
    assert(select("#", select(2, ...)) == 1, "expected a single return value")
    local returned_future = f.second(...)
    assert(type(returned_future) == "function", "type error :: expected func")
    returned_future(step)
  end
end

---@class Future
---Something that will give a value when run

---Executes a future with a callback when it is done
---@param future Future: the future to execute
---@param callback function: the callback to call when done
local execute = function(future, callback)
  assert(type(future) == "function", "type error :: expected func")
  local thread = co.create(future)

  local step
  step = function(...)
    callback_or_next(step, thread, callback, co.resume(thread, ...))
  end

  step()
end

---Creates an async function with a callback style function.
---@param func function: A callback style function to be converted. The last argument must be the callback.
---@param argc number: The number of arguments of func. Must be included.
---@return function: Returns an async function
M.wrap = function(func, argc)
  if type(func) ~= "function" then
    traceback_error("type error :: expected func, got " .. type(func))
  end

  if type(argc) ~= "number" and argc ~= "vararg" then
    traceback_error "expected argc to be a number or string literal 'vararg'"
  end

  return function(...)
    local params = tbl.pack(...)

    local function future(step)
      if step then
        if type(argc) == "number" then
          params[argc] = step
          params.n = argc
        else
          table.insert(params, step) -- change once not optional
          params.n = params.n + 1
        end

        return func(tbl.unpack(params))
      else
        return co.yield(future)
      end
    end
    return future
  end
end

---Return a new future that when run will run all futures concurrently.
---@param futures table: the futures that you want to join
---@return Future: returns a future
M.join = M.wrap(function(futures, step)
  local len = #futures
  local results = {}
  local done = 0

  if len == 0 then
    return step(results)
  end

  for i, future in ipairs(futures) do
    assert(type(future) == "function", "type error :: future must be function")

    local callback = function(...)
      results[i] = { ... }
      done = done + 1
      if done == len then
        step(results)
      end
    end

    future(callback)
  end
end, 2)

---Returns a future that when run will select the first future that finishes
---@param futures table: The future that you want to select
---@return Future
M.select = M.wrap(function(futures, step)
  local selected = false

  for _, future in ipairs(futures) do
    assert(type(future) == "function", "type error :: future must be function")

    local callback = function(...)
      if not selected then
        selected = true
        step(...)
      end
    end

    future(callback)
  end
end, 2)

---Use this to either run a future concurrently and then do something else
---or use it to run a future with a callback in a non async context
---@param future Future
---@param callback function
M.run = function(future, callback)
  future(callback or function() end)
end

---Same as run but runs multiple futures
---@param futures table
---@param callback function
M.run_all = function(futures, callback)
  M.run(M.join(futures), callback)
end

---Await a future, yielding the current function
---@param future Future
---@return any: returns the result of the future when it is done
M.await = function(future)
  assert(type(future) == "function", "type error :: expected function to await")
  return future(nil)
end

---Same as await but can await multiple futures.
---If the futures have libuv leaf futures they will be run concurrently
---@param futures table
---@return table: returns a table of results that each future returned. Note that if the future returns multiple values they will be packed into a table.
M.await_all = function(futures)
  assert(type(futures) == "table", "type error :: expected table")
  return M.await(M.join(futures))
end

---suspend a coroutine
M.suspend = co.yield

---create a async scope
M.scope = function(func)
  M.run(M.future(func))
end

--- Future a :: a -> (a -> ())
--- turns this signature
--- ... -> Future a
--- into this signature
--- ... -> ()
M.void = function(async_func)
  return function(...)
    async_func(...)(function() end)
  end
end

M.async_void = function(func)
  return M.void(M.async(func))
end

---creates an async function
---@param func function
---@return function: returns an async function
M.async = function(func)
  if type(func) ~= "function" then
    traceback_error("type error :: expected func, got " .. type(func))
  end

  return function(...)
    local args = tbl.pack(...)
    local function future(step)
      if step == nil then
        return func(tbl.unpack(args))
      else
        execute(future, step)
      end
    end
    return future
  end
end

---creates a future
---@param func function
---@return Future
M.future = function(func)
  return M.async(func)()
end

---An async function that when awaited will await the scheduler to be able to call the api.
M.scheduler = M.wrap(vim.schedule, 1)

return M

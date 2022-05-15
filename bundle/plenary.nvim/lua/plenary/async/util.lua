local a = require "plenary.async.async"
local vararg = require "plenary.vararg"
-- local control = a.control
local control = require "plenary.async.control"
local channel = control.channel

local M = {}

local defer_swapped = function(timeout, callback)
  vim.defer_fn(callback, timeout)
end

---Sleep for milliseconds
---@param ms number
M.sleep = a.wrap(defer_swapped, 2)

---This will COMPLETELY block neovim
---please just use a.run unless you have a very special usecase
---for example, in plenary test_harness you must use this
---@param async_function Future
---@param timeout number: Stop blocking if the timeout was surpassed. Default 2000.
M.block_on = function(async_function, timeout)
  async_function = M.protected(async_function)

  local stat, ret

  a.run(async_function, function(_stat, ...)
    stat = _stat
    ret = { ... }
  end)

  vim.wait(timeout or 2000, function()
    return stat ~= nil
  end, 20, false)

  if stat == false then
    error(string.format("Blocking on future timed out or was interrupted.\n%s", unpack(ret)))
  end

  return unpack(ret)
end

M.will_block = function(async_func)
  return function()
    M.block_on(async_func)
  end
end

M.join = function(async_fns)
  local len = #async_fns
  local results = {}
  local done = 0

  local tx, rx = channel.oneshot()

  for i, async_fn in ipairs(async_fns) do
    assert(type(async_fn) == "function", "type error :: future must be function")

    local cb = function(...)
      results[i] = { ... }
      done = done + 1
      if done == len then
        tx()
      end
    end

    a.run(async_fn, cb)
  end

  rx()

  return results
end

---Returns a future that when run will select the first async_function that finishes
---@param async_funs table: The async_function that you want to select
---@return ...
M.run_first = a.wrap(function(async_funs, step)
  local ran = false

  for _, future in ipairs(async_funs) do
    assert(type(future) == "function", "type error :: future must be function")

    local callback = function(...)
      if not ran then
        ran = true
        step(...)
      end
    end

    future(callback)
  end
end, 2)

M.run_all = function(async_fns, callback)
  a.run(function()
    M.join(async_fns)
  end, callback)
end

function M.apcall(async_fn, ...)
  local nargs = a.get_leaf_function_argc(async_fn)
  if nargs then
    local tx, rx = channel.oneshot()
    local stat, ret = pcall(async_fn, vararg.rotate(nargs, tx, ...))
    if not stat then
      return stat, ret
    else
      return stat, rx()
    end
  else
    return pcall(async_fn, ...)
  end
end

function M.protected(async_fn)
  return function()
    return M.apcall(async_fn)
  end
end

---An async function that when called will yield to the neovim scheduler to be able to call the api.
M.scheduler = a.wrap(vim.schedule, 1)

return M

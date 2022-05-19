--- I like context managers for Python
--- I want them in Lua.

local context_manager = {}

function context_manager.with(obj, callable)
  -- Wrap functions for people since we're nice
  if type(obj) == "function" then
    obj = coroutine.create(obj)
  end

  if type(obj) == "thread" then
    local ok, context = coroutine.resume(obj)
    assert(ok, "Should have yielded in coroutine.")

    local result = callable(context)

    local done, _ = coroutine.resume(obj)
    assert(done, "Should be done")

    local no_other = not coroutine.resume(obj)
    assert(no_other, "Should not yield anymore, otherwise that would make things complicated")

    return result
  else
    assert(obj.enter)
    assert(obj.exit)

    -- TODO: Callable can be string for vimL function or a lua callable
    local context = obj:enter()
    local result = callable(context)
    obj:exit()

    return result
  end
end

--- @param filename string|table -- If string, used as io.open(filename)
---                                 Else, should be a table with `filename` as an attribute
function context_manager.open(filename, mode)
  if type(filename) == "table" and filename.filename then
    filename = filename.filename
  end

  local file_io = assert(io.open(filename, mode))

  return coroutine.create(function()
    coroutine.yield(file_io)

    file_io:close()
  end)
end

return context_manager

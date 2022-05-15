---@brief [[
--- NOTE: This API is still under construction.
---         It may change in the future :)
---@brief ]]

local lookups = {
  uv = "plenary.async.uv_async",
  util = "plenary.async.util",
  lsp = "plenary.async.lsp",
  api = "plenary.async.api",
  tests = "plenary.async.tests",
  control = "plenary.async.control",
}

local exports = setmetatable(require "plenary.async.async", {
  __index = function(t, k)
    local require_path = lookups[k]
    if not require_path then
      return
    end

    local mod = require(require_path)
    t[k] = mod

    return mod
  end,
})

exports.tests.add_globals = function()
  a = exports
  async = exports.async
  await = exports.await
  await_all = exports.await_all

  -- must prefix with a or stack overflow, plenary.test harness already added it
  a.describe = exports.tests.describe
  -- must prefix with a or stack overflow
  a.it = exports.tests.it
  a.before_each = exports.tests.before_each
  a.after_each = exports.tests.after_each
end

exports.tests.add_to_env = function()
  local env = getfenv(2)

  env.a = exports
  env.async = exports.async
  env.await = exports.await
  env.await_all = exports.await_all

  -- must prefix with a or stack overflow, plenary.test harness already added it
  env.a.describe = exports.tests.describe
  -- must prefix with a or stack overflow
  env.a.it = exports.tests.it
  a.before_each = exports.tests.before_each
  a.after_each = exports.tests.after_each

  setfenv(2, env)
end

return exports

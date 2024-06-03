local assert = require "luassert"

local Path = require "plenary.path"

local tester = {}
tester.debug = false

local get_results_from_contents = function(content)
  local nvim = vim.fn.jobstart(
    { "nvim", "--noplugin", "-u", "scripts/minimal_init.vim", "--headless", "--embed" },
    { rpc = true }
  )

  local result = vim.fn.rpcrequest(nvim, "nvim_exec_lua", content, {})
  assert.are.same(true, result[1], vim.inspect(result))

  local count = 0
  while
    vim.fn.rpcrequest(nvim, "nvim_exec_lua", "return require('telescope.testharness.runner').state.done", {}) ~= true
  do
    count = count + 1
    vim.wait(100)

    -- TODO: Could maybe wait longer, but it's annoying to wait if the test is going to timeout.
    if count > 100 then
      break
    end
  end

  local state = vim.fn.rpcrequest(nvim, "nvim_exec_lua", "return require('telescope.testharness.runner').state", {})
  vim.fn.jobstop(nvim)

  assert.are.same(true, state.done, vim.inspect(state))

  local result_table = {}
  for _, v in ipairs(state.results) do
    table.insert(result_table, v)
  end

  return result_table, state
end

local check_results = function(results, state)
  assert(state, "Must pass state")

  for _, v in ipairs(results) do
    local assertion
    if not v._type or v._type == "are" or v._type == "_default" then
      assertion = assert.are.same
    else
      assertion = assert.are_not.same
    end

    -- TODO: I think it would be nice to be able to see the state,
    -- but it clutters up the test output so much here.
    --
    -- So we would have to consider how to do that I think.
    assertion(v.expected, v.actual, string.format("Test Case: %s // %s", v.location, v.case))
  end
end

tester.run_string = function(contents)
  contents = [[
    return (function()
      local tester = require('telescope.testharness')
      local runner = require('telescope.testharness.runner')
      local helper = require('telescope.testharness.helpers')
      helper.make_globals()
      local ok, msg = pcall(function()
        runner.log("Loading Test")
        ]] .. contents .. [[
      end)
      return {ok, msg or runner.state}
    end)()
  ]]

  check_results(get_results_from_contents(contents))
end

tester.run_file = function(filename)
  local file = "./lua/tests/pickers/" .. filename .. ".lua"
  local path = Path:new(file)

  if not path:exists() then
    assert.are.same("<An existing file>", file)
  end

  local contents = string.format(
    [[
    return (function()
      local runner = require('telescope.testharness.runner')
      local helper = require('telescope.testharness.helpers')
      helper.make_globals()
      local ok, msg = pcall(function()
        runner.log("Loading Test")
        return loadfile("%s")()
      end)
      return {ok, msg or runner.state}
    end)()
  ]],
    path:absolute()
  )

  check_results(get_results_from_contents(contents))
end

tester.not_ = function(val)
  val._type = "are_not"
  return val
end

return tester

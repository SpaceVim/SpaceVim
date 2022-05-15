--[[
local lu = require("luaunit")

local context_manager = require("plenary.context_manager")
local debug_utils = require("plenary.debug_utils")
local Path = require("plenary.path")

local with = context_manager.with
local open = context_manager.open

local README_STR_PATH = vim.fn.fnamemodify(debug_utils.sourced_filepath(), ":h:h:h:h") .. "/README.md"
local README_FIRST_LINE = "# plenary.nvim"

TestContextManager = {}

function TestContextManager:testWorksWithObj()
  local obj_manager = {
    enter = function(self)
      self.result = 10
      return self.result
    end,

    exit = function()
    end,
  }

  local result = with(obj_manager, function(obj)
    return obj
  end)


  lu.assertEquals(10, result)
  lu.assertEquals(obj_manager.result, result)
end


function TestContextManager:testWorksWithCoroutine()
  local co = function()
    coroutine.yield(10)
  end

  local result = with(co, function(obj)
    return obj
  end)

  lu.assertEquals(10, result)
end

function TestContextManager:testDoesNotWorkWithCoroutineWithExtraYields()
  local co = function()
    coroutine.yield(10)

    -- Can't yield twice. That'd be bad and wouldn't make any sense.
    coroutine.yield(10)
  end

  lu.assertError(function()
    with(co, function(obj)
      return obj
    end)
  end)
end

function TestContextManager:testOpenWorks()
  local result = with(open(README_STR_PATH), function(reader)
    return reader:read()
  end)

  lu.assertEquals(result, README_FIRST_LINE)
end

function TestContextManager:testOpenWorksWithPath()
  local p = Path:new(README_STR_PATH)

  local result = with(open(p), function(reader)
    return reader:read()
  end)

  lu.assertEquals(result, README_FIRST_LINE)
end
--]]

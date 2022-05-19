local tbl = require "plenary.tbl"

local function should_fail(fun)
  local stat = pcall(fun)
  assert(not stat, "Function should have errored")
end

describe("tbl utilities", function()
  it("should be able to freeze a table", function()
    local t = { 1, 2, 3 }
    local frozen = tbl.freeze(t)
    assert(t[1] == frozen[1])
    assert(t[2] == frozen[2])
    assert(t[3] == frozen[3])

    should_fail(function()
      frozen[4] = "thisthis"
    end)

    should_fail(function()
      frozen.hello = "asdfasdf"
    end)

    assert(not frozen[5])
    assert(not frozen.hello)
  end)
end)

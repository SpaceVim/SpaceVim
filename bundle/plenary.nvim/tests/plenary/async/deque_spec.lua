local Deque = require("plenary.async.structs").Deque
local eq = assert.are.same

-- just a helper to create the test deque
local function new_deque()
  local deque = Deque.new()
  eq(deque:len(), 0)

  deque:pushleft(1)
  eq(deque:len(), 1)

  deque:pushleft(2)
  eq(deque:len(), 2)

  deque:pushright(3)
  eq(deque:len(), 3)

  deque:pushright(4)
  eq(deque:len(), 4)

  deque:pushright(5)
  eq(deque:len(), 5)

  return deque
end

describe("deque", function()
  it("should allow pushing and popping and finding len", function()
    new_deque()
  end)

  it("should be able to iterate from left", function()
    local deque = new_deque()

    local iter = deque:ipairs_left()

    local i, v = iter()
    eq(i, -2)
    eq(v, 2)

    i, v = iter()
    eq(i, -1)
    eq(v, 1)

    i, v = iter()
    eq(i, 0)
    eq(v, 3)

    i, v = iter()
    eq(i, 1)
    eq(v, 4)

    i, v = iter()
    eq(i, 2)
    eq(v, 5)
  end)

  it("should be able to iterate from right", function()
    local deque = new_deque()

    local iter = deque:ipairs_right()

    local i, v = iter()
    eq(i, 2)
    eq(v, 5)

    i, v = iter()
    eq(i, 1)
    eq(v, 4)

    i, v = iter()
    eq(i, 0)
    eq(v, 3)

    i, v = iter()
    eq(i, -1)
    eq(v, 1)

    i, v = iter()
    eq(i, -2)
    eq(v, 2)
  end)

  it("should allow clearing", function()
    local deque = new_deque()

    deque:clear()

    assert(deque:is_empty())
  end)
end)

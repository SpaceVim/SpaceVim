local LinkedList = require "telescope.algos.linked_list"

describe("LinkedList", function()
  it("can create a list", function()
    local l = LinkedList:new()

    assert.are.same(0, l.size)
  end)

  it("can add a single entry to the list", function()
    local l = LinkedList:new()
    l:append "hello"

    assert.are.same(1, l.size)
  end)

  it("can iterate over one item", function()
    local l = LinkedList:new()
    l:append "hello"

    for val in l:iter() do
      assert.are.same("hello", val)
    end
  end)

  it("iterates in order", function()
    local l = LinkedList:new()
    l:append "hello"
    l:append "world"

    local x = {}
    for val in l:iter() do
      table.insert(x, val)
    end

    assert.are.same({ "hello", "world" }, x)
  end)

  it("iterates in order, for prepend", function()
    local l = LinkedList:new()
    l:prepend "world"
    l:prepend "hello"

    local x = {}
    for val in l:iter() do
      table.insert(x, val)
    end

    assert.are.same({ "hello", "world" }, x)
  end)

  it("iterates in order, for combo", function()
    local l = LinkedList:new()
    l:prepend "world"
    l:prepend "hello"
    l:append "last"
    l:prepend "first"

    local x = {}
    for val in l:iter() do
      table.insert(x, val)
    end

    assert.are.same({ "first", "hello", "world", "last" }, x)
    assert.are.same(#x, l.size)
  end)

  it("has ipairs", function()
    local l = LinkedList:new()
    l:prepend "world"
    l:prepend "hello"
    l:append "last"
    l:prepend "first"

    local x = {}
    for v in l:iter() do
      table.insert(x, v)
    end
    assert.are.same({ "first", "hello", "world", "last" }, x)

    local expected = {}
    for i, v in ipairs(x) do
      table.insert(expected, { i, v })
    end

    local actual = {}
    for i, v in l:ipairs() do
      table.insert(actual, { i, v })
    end

    assert.are.same(expected, actual)
  end)

  describe("track_at", function()
    it("should update tracked when only appending", function()
      local l = LinkedList:new { track_at = 2 }
      l:append "first"
      l:append "second"
      l:append "third"

      assert.are.same("second", l.tracked)
    end)

    it("should update tracked when first some prepend and then append", function()
      local l = LinkedList:new { track_at = 2 }
      l:prepend "first"
      l:append "second"
      l:append "third"

      assert.are.same("second", l.tracked)
    end)

    it("should update when only prepending", function()
      local l = LinkedList:new { track_at = 2 }
      l:prepend "third"
      l:prepend "second"
      l:prepend "first"

      assert.are.same("second", l.tracked)
    end)

    it("should update when lots of prepend and append", function()
      local l = LinkedList:new { track_at = 2 }
      l:prepend "third"
      l:prepend "second"
      l:prepend "first"
      l:append "fourth"
      l:prepend "zeroth"

      assert.are.same("first", l.tracked)
    end)
  end)
end)

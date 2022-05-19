local i = require "plenary.iterators"
local f = require "plenary.functional"
local eq = assert.are.same

local function check_keys(tbl, keys)
  for _, key in ipairs(keys) do
    if not tbl[key] then
      error("Key " .. key .. " was not found")
    end
  end
end

describe("iterators", function()
  it("should be able to create iterator from table", function()
    local tbl = { first = 1, second = 2, third = 3, fourth = 4 }
    local results = i.iter(tbl):tolist()
    eq(#results, 4)
    check_keys(tbl, { "first", "second", "third", "fourth" })
    results = {
      { "first", 1 },
      { "second", 2 },
      { "third", 3 },
      { "fourth", 4 },
    }
  end)

  it("should be able to create iterator from array", function()
    local tbl = { 1, 2, 3, 4 }
    local results = i.iter(tbl):tolist()
    eq(#results, 4)
    check_keys(tbl, { 1, 2, 3, 4 })
  end)

  it("should be able to find", function()
    local tbl = { 1, 2, 3, 4 }
    local tbl_iter = i.iter(tbl)
    local res = tbl_iter:find(2)
    eq(res, 2)
    res = tbl_iter:find "will not find this"
    assert(not res)

    tbl = { 1, 2, 3, 4, "some random string", 6 }
    eq(
      i.iter(tbl):find(function(x)
        return type(x) == "string"
      end),
      "some random string"
    )
  end)

  it("should be table to chain", function()
    local first = i.iter { 1, 2, 3 }
    local second = i.iter { 4, 5, 6, 7 }
    local third = i.iter { 8, 9, 10 }
    local res = (first .. second .. third):tolist()
    eq(res, i.range(10):tolist())
  end)

  it("should make a range", function()
    eq({ 1, 2, 3, 4, 5 }, i.range(5):tolist())
  end)

  it("should be able to make a stateful", function()
    local iter = i.range(3):stateful()
    eq(iter(), 1)
    eq(iter(), 2)
    eq(iter(), 3)
    assert(not iter())
    assert(not iter())
    assert(not iter())

    local iter = i.range(3):stateful()
    -- dump(iter:tolist())
    eq(iter:tolist(), { 1, 2, 3 })
  end)

  it("should be able to flatten", function()
    local iter = i.range(3)
      :map(function(_)
        return i.iter { 5, 7, 9 }
      end)
      :flatten()
      :stateful()
    eq(iter(), 5)
    eq(iter(), 7)
    eq(iter(), 9)
    eq(iter(), 5)
    eq(iter(), 7)
    eq(iter(), 9)
    eq(iter(), 5)
    eq(iter(), 7)
    eq(iter(), 9)
    local iter = i.range(3)
      :map(function(_)
        return i.iter { 5, 7, 9 }
      end)
      :flatten()
    eq(iter:tolist(), { 5, 7, 9, 5, 7, 9, 5, 7, 9 })
  end)

  it("should be able to flatten very nested stuff", function()
    local iter = i.iter({ 5, 6, i.iter { i.iter { 5, 5 }, 7, 8 }, i.iter { 9, 10, i.iter { 1, 2 } } }):flatten()
    eq(iter:tolist(), { 5, 6, 5, 5, 7, 8, 9, 10, 1, 2 })
  end)

  it("chaining nil should work", function()
    local iter = i.iter(""):chain(i.iter { 5, 7, 9 })
    eq(#iter:tolist(), 3)
  end)

  describe("generators", function()
    it("should be able to split", function()
      local iter = i.split(" hello person world ", " ")
      eq(iter:tolist(), { "", "hello", "person", "world", "" })

      iter = i.split("\n\n\nfirst\nsecond\nthird\n\n", "\n")
      eq(iter:tolist(), { "", "", "", "first", "second", "third", "", "" })
    end)
  end)
end)

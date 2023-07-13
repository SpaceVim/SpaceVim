local lfu = require("cmp_dictionary.lfu")

local cache

describe("Test for lfu.lua", function()
  before_each(function()
    cache = lfu.init(3)
  end)

  it("single cache", function()
    cache:set("a", 1)
    assert.are.equals(1, cache:get("a"))
  end)

  it("remove the least frequent cache", function()
    cache:set("a", 1)
    cache:set("b", 2)
    cache:set("c", 3)
    assert.are.equals(1, cache:get("a")) -- freq = 2
    assert.are.equals(1, cache:get("a")) -- freq = 3
    assert.are.equals(2, cache:get("b")) -- freq = 2
    assert.are.equals(3, cache:get("c")) -- freq = 2

    cache:set("d", 4)
    -- Removed the least frequent cache with the oldest accesses.
    assert.is_nil(cache:get("b"))
  end)
end)

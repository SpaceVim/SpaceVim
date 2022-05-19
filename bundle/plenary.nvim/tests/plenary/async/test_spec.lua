require("plenary.async").tests.add_to_env()

a.describe("a.before_each", function()
  local counter = 0

  local set_counter_to_one = a.wrap(function(callback)
    a.util.sleep(5)
    counter = 1
  end, 1)

  a.before_each(a.void(function()
    set_counter_to_one()
  end))

  a.it("should run in async context", function()
    counter = counter + 1
    assert.are.same(counter, 2)
  end)

  a.it("should run for all tests", function()
    counter = counter + 2
    assert.are.same(counter, 3)
  end)
end)

a.describe("a.after_each", function()
  local counter = 0

  local set_counter_to_one = a.wrap(function(callback)
    a.util.sleep(5)
    counter = 1
  end, 1)

  a.after_each(a.void(function()
    set_counter_to_one()
  end))

  a.it("should not run before first test", function()
    counter = counter + 1
    assert.are.same(counter, 1)
  end)

  a.it("should run before the second test", function()
    counter = counter + 2
    assert.are.same(counter, 3)
  end)

  a.it("should run before the third test", function()
    counter = counter + 3
    assert.are.same(counter, 4)
  end)
end)

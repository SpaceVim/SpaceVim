local eq = assert.are.same

local tester_function = function()
  error(7)
end

describe("busted specs", function()
  describe("nested", function()
    it("should work", function()
      assert(true)
    end)
  end)

  it("should not nest", function()
    assert(true)
  end)

  it("should not fail unless we unpcall this", function()
    pcall(tester_function)
  end)

  pending("other thing pending", function()
    error()
  end)
end)

describe("before each", function()
  local a = 2
  local b = 3
  it("is not cleared", function()
    eq(2, a)
    eq(3, b)
    a = a + 1
    b = b + 1
  end)
  describe("nested", function()
    before_each(function()
      a = 0
    end)
    it("should clear a but not b", function()
      eq(0, a)
      eq(4, b)
      a = a + 1
      b = b + 1
    end)
    describe("nested nested", function()
      before_each(function()
        b = 0
      end)
      it("should clear b as well", function()
        eq(0, a)
        eq(0, b)
        a = a + 1
        b = b + 1
      end)
    end)
    it("should only clear a", function()
      eq(0, a)
      eq(1, b)
      a = a + 1
      b = b + 1
    end)
  end)
  it("should clear nothing", function()
    eq(1, a)
    eq(2, b)
  end)
end)

describe("after each", function()
  local a = 2
  local b = 3
  it("is not cleared", function()
    eq(2, a)
    eq(3, b)
    a = a + 1
    b = b + 1
  end)
  describe("nested", function()
    after_each(function()
      a = 0
    end)
    it("should not clear any at this point", function()
      eq(3, a)
      eq(4, b)
      a = a + 1
      b = b + 1
    end)
    describe("nested nested", function()
      after_each(function()
        b = 0
      end)
      it("should have cleared a", function()
        eq(0, a)
        eq(5, b)
        a = a + 1
        b = b + 1
      end)
    end)
    it("should have cleared a and b", function()
      eq(0, a)
      eq(0, b)
      a = a + 1
      b = b + 1
    end)
  end)
  it("should only have cleared a", function()
    eq(0, a)
    eq(1, b)
  end)
end)

describe("fourth top level describe test", function()
  it("should work", function()
    eq(1, 1)
  end)
end)

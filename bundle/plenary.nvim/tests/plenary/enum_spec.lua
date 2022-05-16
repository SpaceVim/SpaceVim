local Enum = require "plenary.enum"

local function should_fail(fun)
  local stat = pcall(fun)
  assert(not stat, "Function should fail")
end

describe("Enum", function()
  it("should be able to define specific values for members", function()
    local E = Enum {
      { "Foo", 2 },
      { "Bar", 4 },
      "Qux",
      "Baz",
      { "Another", 11 },
    }

    assert(E.Foo.value == 2)
    assert(E.Bar.value == 4)
    assert(E.Qux.value == 5)
    assert(E.Baz.value == 6)
    assert(E.Another.value == 11)

    assert(E[2] == "Foo")
    assert(E[4] == "Bar")
    assert(E[5] == "Qux")
    assert(E[6] == "Baz")
    assert(E[11] == "Another")
  end)
  it("should compare with itself", function()
    local E1 = Enum {
      "Foo",
      { "Qux", 11 },
      "Bar",
      "Baz",
    }

    local E2 = Enum {
      "Foo",
      "Bar",
      "Baz",
    }

    assert(E1.Foo < E1.Qux)
    assert(E1.Baz > E1.Bar)

    assert(not (E1.Foo == E2.Foo))

    should_fail(function()
      return E1.Foo > E2.Foo
    end)

    should_fail(function()
      return E2.Bar >= E1.Foo
    end)
  end)
  it("should error when accessing invalid field", function()
    local E = Enum {
      "Foo",
      "Bar",
      "Baz",
    }

    should_fail(function()
      return E.foo
    end)

    should_fail(function()
      return E.bar
    end)
  end)
  it("should fail if there is name or index clashing", function()
    should_fail(function()
      return Enum {
        "Foo",
        "Foo",
      }
    end)
    should_fail(function()
      return Enum {
        "Foo",
        { "Bar", 1 },
      }
    end)
  end)
  it("should fail if there is a key that starts with lowercase", function()
    should_fail(function()
      return Enum {
        "foo",
      }
    end)
  end)
end)

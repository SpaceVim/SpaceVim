require("plenary.async").tests.add_to_env()

describe("async", function()
  a.it("void functions can call wrapped functions", function()
    local stat = 0
    local saved_arg

    local wrapped = a.wrap(function(inc, callback)
      stat = stat + inc
      callback()
    end, 2)

    local voided = a.void(function(arg)
      wrapped(1)
      wrapped(2)
      wrapped(3)
      stat = stat + 1
      saved_arg = arg
    end)

    voided "hello"

    assert(stat == 7)
    assert(saved_arg == "hello")
  end)

  a.it("void functions can call wrapped functions with ignored arguments", function()
    local stat = 0
    local saved_arg

    local wrapped = a.wrap(function(inc, nil1, nil2, callback)
      assert(type(inc) == "number")
      assert(nil1 == nil)
      assert(nil2 == nil)
      assert(type(callback) == "function")
      stat = stat + inc
      callback()
    end, 4)

    local voided = a.void(function(arg)
      wrapped(1)
      wrapped(2, nil)
      wrapped(3, nil, nil)
      stat = stat + 1
      saved_arg = arg
    end)

    voided "hello"

    assert(stat == 7)
    assert(saved_arg == "hello")
  end)
end)

require("plenary.async").tests.add_to_env()
local Condvar = a.control.Condvar
local eq = assert.are.same
local join, run_all = a.util.join, a.util.run_all

describe("condvar", function()
  a.it("should allow blocking", function()
    local var = false

    local condvar = Condvar.new()

    a.run(function()
      condvar:wait()
      var = true
    end)

    eq(var, false)

    condvar:notify_one()

    eq(var, true)
  end)

  a.it("should be able to notify one when running", function()
    local counter = 0

    local condvar = Condvar.new()

    local first = function()
      condvar:wait()
      counter = counter + 1
    end

    local second = function()
      condvar:wait()
      counter = counter + 1
    end

    local third = function()
      condvar:wait()
      counter = counter + 1
    end

    a.run(function()
      join { first, second, third }
    end)

    eq(0, counter)

    condvar:notify_one()

    eq(1, counter)

    condvar:notify_one()

    eq(counter, 2)

    condvar:notify_one()

    eq(counter, 3)
  end)

  a.it("should allow notify_one to work when using await_all", function()
    local counter = 0

    local condvar = Condvar.new()

    local first = function()
      condvar:wait()
      counter = counter + 1
    end

    local second = function()
      condvar:wait()
      counter = counter + 1
    end

    local third = function()
      condvar:wait()
      counter = counter + 1
    end

    run_all { first, second, third }

    eq(0, counter)

    condvar:notify_one()

    eq(1, counter)

    condvar:notify_one()

    eq(counter, 2)

    condvar:notify_one()

    eq(counter, 3)
  end)

  a.it("should notify_all", function()
    local counter = 0

    local condvar = Condvar.new()

    local first = function()
      condvar:wait()
      counter = counter + 1
    end

    local second = function()
      condvar:wait()
      counter = counter + 1
    end

    local third = function()
      condvar:wait()
      counter = counter + 1
    end

    run_all { first, second, third }

    eq(0, counter)

    condvar:notify_all()

    eq(3, counter)
  end)
end)

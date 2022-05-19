require("plenary.async").tests.add_to_env()
local Semaphore = a.control.Semaphore

local eq = assert.are.same

describe("semaphore", function()
  a.it("should validate arguments", function()
    local status = pcall(Semaphore.new, -1)
    eq(status, false)

    local status = pcall(Semaphore.new)
    eq(status, false)
  end)

  a.it("should acquire a permit if available", function()
    local sem = Semaphore.new(1)
    local permit = sem:acquire()
    assert(permit ~= nil)
  end)

  a.it("should block if no permit is available", function()
    local sem = Semaphore.new(1)
    sem:acquire()

    local completed = false
    local blocking = function()
      sem:acquire()
      completed = true
    end
    a.run(blocking)

    eq(completed, false)
  end)

  a.it("should give another permit when an acquired permit is released", function()
    local sem = Semaphore.new(1)
    local permit = sem:acquire()
    permit:forget()
    local next_permit = sem:acquire()
    assert(next_permit ~= nil)
  end)

  a.it("should permit the next waiting client when a permit is released", function()
    local sem = Semaphore.new(1)
    local permit = sem:acquire()

    local completed = false
    local blocking = function()
      sem:acquire()
      completed = true
    end

    a.run(blocking)
    permit:forget()

    eq(completed, true)
  end)
end)

local Job = require "plenary.job"

describe("Job Validation", function()
  it("does not require command when called with array method", function()
    local ok, j = pcall(Job.new, Job, { "ls" })
    assert(ok, "Accepts positional arguments")
    assert(j.command == "ls")
  end)

  it("cannot use command and array syntax", function()
    local ok = pcall(Job.new, Job, { "ls", command = "ls" })
    assert(not ok, "cannot use command and array syntax")
  end)

  it("can parse command and args from array syntax", function()
    local ok, j = pcall(Job.new, Job, { "ls", "-al" })
    assert(ok, "Accepts positional arguments")
    assert(j.command == "ls")
    assert.are.same({ "-al" }, j.args)
  end)

  it("can parse command and multiple args from array syntax", function()
    local ok, j = pcall(Job.new, Job, { "ls", "-al", "~" })
    assert(ok, "Accepts positional arguments")
    assert(j.command == "ls")
    assert.are.same({ "-al", "~" }, j.args)
  end)
end)

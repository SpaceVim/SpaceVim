pcall(require, "luacov")

describe("Event queue", function()
  it("should return data when handled = true", function()
    local events = require("neo-tree.events")
    events.subscribe({
      event = "test",
      handler = function()
        return { data = "first" }
      end,
    })
    events.subscribe({
      event = "test",
      handler = function()
        return { handled = true, data = "second" }
      end,
    })
    events.subscribe({
      event = "test",
      handler = function()
        return { data = "third" }
      end,
    })
    local result = events.fire_event("test") or {}
    local data = result.data
    assert.are.same("second", data)
  end)
end)

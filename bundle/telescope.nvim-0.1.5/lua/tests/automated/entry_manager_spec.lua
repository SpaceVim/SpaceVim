local EntryManager = require "telescope.entry_manager"

local eq = assert.are.same

describe("process_result", function()
  it("works with one entry", function()
    local manager = EntryManager:new(5, nil)

    manager:add_entry(nil, 1, "hello", "")

    eq(1, manager:get_score(1))
  end)

  it("works with two entries", function()
    local manager = EntryManager:new(5, nil)

    manager:add_entry(nil, 1, "hello", "")
    manager:add_entry(nil, 2, "later", "")

    eq(2, manager.linked_states.size)

    eq("hello", manager:get_entry(1))
    eq("later", manager:get_entry(2))
  end)

  it("calls functions when inserting", function()
    local called_count = 0
    local manager = EntryManager:new(5, function()
      called_count = called_count + 1
    end)

    assert(called_count == 0)
    manager:add_entry(nil, 1, "hello", "")
    assert(called_count == 1)
  end)

  it("calls functions when inserting twice", function()
    local called_count = 0
    local manager = EntryManager:new(5, function()
      called_count = called_count + 1
    end)

    assert(called_count == 0)
    manager:add_entry(nil, 1, "hello", "")
    manager:add_entry(nil, 2, "world", "")
    assert(called_count == 2)
  end)

  it("correctly sorts lower scores", function()
    local called_count = 0
    local manager = EntryManager:new(5, function()
      called_count = called_count + 1
    end)
    manager:add_entry(nil, 5, "worse result", "")
    manager:add_entry(nil, 2, "better result", "")

    eq("better result", manager:get_entry(1))
    eq("worse result", manager:get_entry(2))

    eq(2, called_count)
  end)

  it("respects max results", function()
    local called_count = 0
    local manager = EntryManager:new(1, function()
      called_count = called_count + 1
    end)
    manager:add_entry(nil, 2, "better result", "")
    manager:add_entry(nil, 5, "worse result", "")

    eq("better result", manager:get_entry(1))
    eq(1, called_count)
  end)

  it("should allow simple entries", function()
    local manager = EntryManager:new(5)

    local counts_executed = 0
    manager:add_entry(
      nil,
      1,
      setmetatable({}, {
        __index = function(t, k)
          local val = nil
          if k == "ordinal" then
            counts_executed = counts_executed + 1

            -- This could be expensive, only call later
            val = "wow"
          end

          rawset(t, k, val)
          return val
        end,
      }),
      ""
    )

    eq("wow", manager:get_ordinal(1))
    eq("wow", manager:get_ordinal(1))
    eq("wow", manager:get_ordinal(1))

    eq(1, counts_executed)
  end)

  it("should not loop a bunch", function()
    local info = {}
    local manager = EntryManager:new(5, nil, info)
    manager:add_entry(nil, 4, "better result", "")
    manager:add_entry(nil, 3, "better result", "")
    manager:add_entry(nil, 2, "better result", "")

    -- Loops once to find 3 < 4
    -- Loops again to find 2 < 3
    eq(2, info.looped)
  end)

  it("should not loop a bunch, part 2", function()
    local info = {}
    local manager = EntryManager:new(5, nil, info)
    manager:add_entry(nil, 4, "better result", "")
    manager:add_entry(nil, 2, "better result", "")
    manager:add_entry(nil, 3, "better result", "")

    -- Loops again to find 2 < 4
    -- Loops once to find 3 > 2
    --  but less than 4
    eq(3, info.looped)
  end)

  it("should update worst score in all append case", function()
    local manager = EntryManager:new(2, nil)
    manager:add_entry(nil, 2, "result 2", "")
    manager:add_entry(nil, 3, "result 3", "")
    manager:add_entry(nil, 4, "result 4", "")

    eq(3, manager.worst_acceptable_score)
  end)

  it("should update worst score in all prepend case", function()
    local called_count = 0
    local manager = EntryManager:new(2, function()
      called_count = called_count + 1
    end)
    manager:add_entry(nil, 5, "worse result", "")
    manager:add_entry(nil, 4, "less worse result", "")
    manager:add_entry(nil, 2, "better result", "")

    -- Once for insert 5
    -- Once for prepend 4
    -- Once for prepend 2
    eq(3, called_count)

    eq("better result", manager:get_entry(1))
    eq(4, manager.worst_acceptable_score)
  end)

  it("should call tiebreaker if score is the same, sort length", function()
    local manager = EntryManager:new(5, nil)
    local picker = {
      tiebreak = function(curr, prev, prompt)
        eq("asdf", prompt)
        return #curr < #prev
      end,
    }

    manager:add_entry(picker, 0.5, "same same", "asdf")
    manager:add_entry(picker, 0.5, "same", "asdf")

    eq("same", manager:get_entry(1))
    eq("same same", manager:get_entry(2))
  end)

  it("should call tiebreaker if score is the same, keep initial", function()
    local manager = EntryManager:new(5, nil)
    local picker = {
      tiebreak = function(_, _, prompt)
        eq("asdf", prompt)
        return false
      end,
    }

    manager:add_entry(picker, 0.5, "same same", "asdf")
    manager:add_entry(picker, 0.5, "same", "asdf")

    eq("same", manager:get_entry(2))
    eq("same same", manager:get_entry(1))
  end)
end)

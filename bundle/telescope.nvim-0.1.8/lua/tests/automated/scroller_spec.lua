local p_scroller = require "telescope.pickers.scroller"

local log = require "telescope.log"
log.use_console = false

local eq = assert.are.same

describe("scroller", function()
  local max_results = 10

  describe("ascending cycle", function()
    local cycle_scroller = p_scroller.create("cycle", "ascending")

    it("should return values within the max results", function()
      eq(5, cycle_scroller(max_results, max_results, 5))
    end)

    it("should return 0 at 0", function()
      eq(0, cycle_scroller(max_results, max_results, 0))
    end)

    it("should cycle you to the top when you go below 0", function()
      eq(max_results - 1, cycle_scroller(max_results, max_results, -1))
    end)

    it("should cycle you to 0 when you go past the results", function()
      eq(0, cycle_scroller(max_results, max_results, max_results + 1))
    end)

    it("should cycle when current results is less than max_results", function()
      eq(0, cycle_scroller(max_results, 5, 7))
    end)
  end)

  describe("ascending limit", function()
    local limit_scroller = p_scroller.create("limit", "ascending")

    it("should return values within the max results", function()
      eq(5, limit_scroller(max_results, max_results, 5))
    end)

    it("should return 0 at 0", function()
      eq(0, limit_scroller(max_results, max_results, 0))
    end)

    it("should not cycle", function()
      eq(0, limit_scroller(max_results, max_results, -1))
    end)

    it("should not cycle you to 0 when you go past the results", function()
      eq(max_results - 1, limit_scroller(max_results, max_results, max_results + 1))
    end)

    it("should stay at current results when current results is less than max_results", function()
      local current = 5
      eq(current - 1, limit_scroller(max_results, current, 7))
    end)
  end)

  describe("descending cycle", function()
    local cycle_scroller = p_scroller.create("cycle", "descending")

    it("should return values within the max results", function()
      eq(5, cycle_scroller(max_results, max_results, 5))
    end)

    it("should return max_results - 1 at 0", function()
      eq(0, cycle_scroller(max_results, max_results, 0))
    end)

    it("should cycle you to the bot when you go below 0", function()
      eq(max_results - 1, cycle_scroller(max_results, max_results, -1))
    end)

    it("should cycle you to 0 when you go past the results", function()
      eq(0, cycle_scroller(max_results, max_results, max_results + 1))
    end)

    it("should cycle when current results is less than max_results", function()
      eq(9, cycle_scroller(max_results, 5, 4))
    end)
  end)

  describe("descending limit", function()
    local limit_scroller = p_scroller.create("limit", "descending")

    it("should return values within the max results", function()
      eq(5, limit_scroller(max_results, max_results, 5))
    end)

    it("should return 0 at 0", function()
      eq(0, limit_scroller(max_results, max_results, 0))
    end)

    it("should not cycle", function()
      eq(0, limit_scroller(max_results, max_results, -1))
    end)

    it("should not cycle you to 0 when you go past the results", function()
      eq(max_results - 1, limit_scroller(max_results, max_results, max_results + 1))
    end)

    it("should stay at current results when current results is less than max_results", function()
      local current = 5
      eq(max_results - current, limit_scroller(max_results, current, 4))
    end)
  end)

  describe("https://github.com/nvim-telescope/telescope.nvim/pull/293#issuecomment-751463224", function()
    it("should handle having many more results than necessary", function()
      local scroller = p_scroller.create("cycle", "descending")

      -- 23 112 23
      eq(0, scroller(23, 112, 23))
    end)
  end)

  describe("should give top, middle and bottom index", function()
    it("should handle ascending", function()
      eq(0, p_scroller.top("ascending", 20, 1000))
      eq(19, p_scroller.bottom("ascending", 20, 1000))

      eq(0, p_scroller.top("ascending", 20, 10))
      eq(9, p_scroller.bottom("ascending", 20, 10))

      eq(5, p_scroller.middle("ascending", 11, 100))
      eq(10, p_scroller.middle("ascending", 20, 100))
      eq(12, p_scroller.middle("ascending", 25, 100))
    end)

    it("should handle descending", function()
      eq(0, p_scroller.top("descending", 20, 1000))
      eq(19, p_scroller.bottom("descending", 20, 1000))

      eq(10, p_scroller.top("descending", 20, 10))
      eq(19, p_scroller.bottom("descending", 20, 10))

      eq(25, p_scroller.middle("descending", 30, 10))
      eq(50, p_scroller.middle("descending", 60, 20))
      eq(105, p_scroller.middle("descending", 120, 30))
    end)
  end)
end)

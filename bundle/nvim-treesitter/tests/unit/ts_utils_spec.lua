local tsutils = require "nvim-treesitter.ts_utils"

describe("is_in_node_range", function()
  local function test_is_in_node_range(line, col)
    local node = {
      range = function()
        return unpack { 0, 3, 2, 5 }
      end,
    }
    return tsutils.is_in_node_range(node, line, col)
  end

  it("returns false before node start", function()
    assert.is_false(test_is_in_node_range(0, 0))
    assert.is_false(test_is_in_node_range(0, 1))
    assert.is_false(test_is_in_node_range(0, 2))
  end)

  it("returns true at node start", function()
    assert.is_true(test_is_in_node_range(0, 3))
  end)

  it("returns true on first line of the node", function()
    assert.is_true(test_is_in_node_range(0, 4))
  end)

  it("returns true between node lines", function()
    assert.is_true(test_is_in_node_range(1, 2))
    assert.is_true(test_is_in_node_range(1, 20))
  end)

  it("returns false on node end", function()
    -- Ranges are end-exclusive
    assert.is_false(test_is_in_node_range(2, 5))
  end)

  it("returns false after node end", function()
    assert.is_false(test_is_in_node_range(2, 6))
    assert.is_false(test_is_in_node_range(3, 0))
  end)
end)

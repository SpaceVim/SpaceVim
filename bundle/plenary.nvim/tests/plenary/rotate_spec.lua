local rotate = require("plenary.vararg").rotate

local eq = vim.deep_equal

describe("rotate", function()
  it("should rotate varargs", function()
    eq({ rotate(1, 2, 3) }, { 2, 3, 1 })
    eq({ rotate(1, 2, 3, 4, 5, 6, 7, 8, 9) }, { 2, 3, 4, 5, 6, 7, 8, 9, 1 })
  end)

  it("should rotate none", function()
    eq({ rotate() }, {})
  end)

  it("should rotate one", function()
    eq({ rotate(1) }, { 1 })
  end)
end)

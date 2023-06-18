local Runner = require("tests.indent.common").Runner

local run = Runner:new(it, "tests/indent/usd", {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
})

describe("indent USD:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("prim.usd", { on_line = 3, text = "active = false", indent = 4 })
    run:new_line("prim.usd", { on_line = 5, text = "custom int foo = 10", indent = 4 })
  end)
end)

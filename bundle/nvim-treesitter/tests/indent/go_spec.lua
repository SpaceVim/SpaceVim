local Runner = require("tests.indent.common").Runner
--local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent/go", {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = false,
})

describe("indent Go:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("issue-2369.go", { on_line = 13, text = "// some comment", indent = 1 })
  end)
end)

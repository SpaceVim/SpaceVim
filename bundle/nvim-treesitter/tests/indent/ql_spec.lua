local Runner = require("tests.indent.common").Runner

local run = Runner:new(it, "tests/indent/ql", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 0,
  expandtab = true,
})

describe("indent Lua:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)
end)

describe("new line:", function()
  run:new_line("module.ql", { on_line = 1, text = "predicate foo() {}", indent = 2 })
end)

describe("new line:", function()
  run:new_line("module.ql", { on_line = 2, text = "predicate foo() {}", indent = 2 })
end)

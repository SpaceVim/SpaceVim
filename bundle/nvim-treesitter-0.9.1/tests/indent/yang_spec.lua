local Runner = require("tests.indent.common").Runner

local run = Runner:new(it, "tests/indent/yang", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 0,
  expandtab = true,
})

describe("indent YANG:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("module.yang", { on_line = 12, text = "// Aligned indentation ended", indent = 2 })
    run:new_line("module.yang", { on_line = 37, text = "// Test", indent = 4 })
    run:new_line("module.yang", { on_line = 40, text = "// Test", indent = 4 })
    run:new_line("module.yang", { on_line = 52, text = "Aligned string!", indent = 11 })
  end)
end)

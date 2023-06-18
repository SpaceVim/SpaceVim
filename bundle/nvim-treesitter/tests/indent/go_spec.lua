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

  describe("new lines:", function()
    run:new_line("issue-2369.go", { on_line = 13, text = "// some comment", indent = 1 })
    run:new_line("issue-2369-newline.go", { on_line = 8, text = "// comment", indent = 0 })
    run:new_line("const_declaration.go", { on_line = 3, text = "Constant", indent = 1 })
    run:new_line("const_declaration.go", { on_line = 7, text = "func main() {", indent = 0 })
  end)
end)

local Runner = require("tests.indent.common").Runner
local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent/java", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 0,
  expandtab = true,
})

describe("indent Java:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("method.java", { on_line = 1, text = "void foo() {}", indent = 2 })
    run:new_line("issue_2571.java", { on_line = 5, text = "void bar() {}", indent = 2 })
    run:new_line("enum.java", { on_line = 2, text = "THING_B,", indent = 2 })
    run:new_line("class_with_annotation.java", { on_line = 2, text = "void foo() {}", indent = 2 })
    run:new_line("enum_with_annotation.java", { on_line = 2, text = "THING;", indent = 2 })
    run:new_line("interface.java", { on_line = 1, text = "void foo();", indent = 2 })
    run:new_line("javadoc.java", { on_line = 2, text = "* Sample javadoc line", indent = 3 })
    run:new_line(
      "issue_2583.java",
      { on_line = 3, text = "int x = 1;", indent = 4 },
      "fails because tree is in a broken state",
      XFAIL
    )
    run:new_line("issue_2583.java", { on_line = 4, text = "int x = 1;", indent = 4 })
    run:new_line("method_chaining.java", { on_line = 4, text = '.append("b");', indent = 6 })
  end)
end)

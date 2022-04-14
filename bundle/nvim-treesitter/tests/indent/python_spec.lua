local Runner = require("tests.indent.common").Runner
local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent/python", {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 0,
  expandtab = true,
})

describe("indent Python:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("aligned_indent.py", { on_line = 1, text = "arg3,", indent = 19 })
    run:new_line("basic_blocks.py", { on_line = 1, text = "wait,", indent = 4 })
    run:new_line("basic_blocks.py", { on_line = 6, text = "x += 1", indent = 4 })
    run:new_line("basic_blocks.py", { on_line = 10, text = "x += 1", indent = 8 })
    run:new_line("basic_blocks.py", { on_line = 7, text = "x += 1", indent = 4 })
    run:new_line("basic_blocks.py", { on_line = 11, text = "x += 1", indent = 8 })
    run:new_line("basic_collections.py", { on_line = 3, text = "4,", indent = 4 })
    run:new_line("comprehensions.py", { on_line = 8, text = "if x != 2", indent = 4 })
    run:new_line("control_flow.py", { on_line = 22, text = "x = 4", indent = 4 })
    run:new_line("hanging_indent.py", { on_line = 1, text = "arg0,", indent = 8 })
    run:new_line("hanging_indent.py", { on_line = 5, text = "0,", indent = 4 })
    run:new_line(
      "join_lines.py",
      { on_line = 1, text = "+ 1 \\", indent = 4 },
      "fails due two not working query at python/indent.scm:30",
      XFAIL
    )
    run:new_line(
      "join_lines.py",
      { on_line = 4, text = "+ 1 \\", indent = 4 },
      "fails due two not working query at python/indent.scm:30",
      XFAIL
    )
    run:new_line("join_lines.py", { on_line = 7, text = "+ 1 \\", indent = 4 })
    run:new_line("nested_collections.py", { on_line = 5, text = "0,", indent = 12 })
    run:new_line("nested_collections.py", { on_line = 6, text = ",0", indent = 12 })
    run:new_line("nested_collections.py", { on_line = 29, text = "[1, 2],", indent = 12 })
    run:new_line("nested_collections.py", { on_line = 39, text = "0,", indent = 5 })
    run:new_line("strings.py", { on_line = 14, text = "x", indent = 4 })
    run:new_line("strings.py", { on_line = 15, text = "x", indent = 0 })
    run:new_line("strings.py", { on_line = 16, text = "x", indent = 8 })
  end)
end)

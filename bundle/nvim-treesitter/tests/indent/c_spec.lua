local Runner = require("tests.indent.common").Runner
local XFAIL = require("tests.indent.common").XFAIL

local runner = Runner:new(it, "tests/indent/c", {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 0,
  expandtab = true,
})

describe("indent C:", function()
  describe("whole file:", function()
    runner:whole_file(".", {
      expected_failures = {
        "./preproc_func.c",
        "./unfinished_comment.c",
      },
    })
  end)

  describe("new line:", function()
    runner:new_line("array.c", { on_line = 2, text = "0,", indent = 4 })
    runner:new_line("compound_lit.c", { on_line = 7, text = ".z = 5,", indent = 8 })
    runner:new_line("cond.c", { on_line = 3, text = "x++;", indent = 8 })
    runner:new_line("cond.c", { on_line = 6, text = "x++;", indent = 8 })
    runner:new_line("cond.c", { on_line = 8, text = "x++;", indent = 8 })
    runner:new_line("cond.c", { on_line = 9, text = "x++;", indent = 4 })
    runner:new_line("expr.c", { on_line = 10, text = "2 *", indent = 8 })
    runner:new_line("func.c", { on_line = 17, text = "int z,", indent = 4 })
    runner:new_line("label.c", { on_line = 3, text = "normal:", indent = 0 })
    runner:new_line("loop.c", { on_line = 3, text = "x++;", indent = 8 })
    runner:new_line("preproc_cond.c", { on_line = 5, text = "x++;", indent = 4 })
    runner:new_line("preproc_func.c", { on_line = 3, text = "x++; \\", indent = 8 }, "expected failure", XFAIL)
    runner:new_line("string.c", { on_line = 1, text = "brave new \\", indent = 0 })
    runner:new_line("string.c", { on_line = 4, text = '"brave new "', indent = 4 })
    runner:new_line("struct.c", { on_line = 4, text = "int y;", indent = 8 })
    runner:new_line("switch.c", { on_line = 3, text = "x++;", indent = 12 })
    runner:new_line("ternary.c", { on_line = 4, text = ": (x == 0) : 0", indent = 8 })
    runner:new_line("issue-1568.c", { on_line = 4, text = "x++;", indent = 8 })
    runner:new_line("issue-2086.c", { on_line = 3, text = "}", indent = 0 })
    -- the line after inserted one will be left with wrong indent but we only care about the inserted one
    runner:new_line("no_braces.c", { on_line = 4, text = "x++;", indent = 8 })
    runner:new_line("no_braces.c", { on_line = 7, text = "x++;", indent = 8 })
    runner:new_line("no_braces.c", { on_line = 10, text = "x++;", indent = 8 })
  end)
end)

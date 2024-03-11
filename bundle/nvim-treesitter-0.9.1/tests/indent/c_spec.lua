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
    runner:new_line("issue-4079.c", { on_line = 2, text = "return;", indent = 8 })
    runner:new_line("issue-4079.c", { on_line = 2, text = "{", indent = 4 })
    runner:new_line("issue-4079.c", { on_line = 6, text = "{", indent = 4 })
    runner:new_line("issue-4117.c", { on_line = 3, text = "else", indent = 4 })
    -- the line after inserted one will be left with wrong indent but we only care about the inserted one
    for _, line in ipairs { 2, 4, 7, 10 } do
      runner:new_line("no_braces.c", { on_line = line, text = "x++;", indent = 8 })
    end
    for _, line in ipairs { 2, 5, 7, 10, 12, 14, 20, 22, 25, 27, 28, 33 } do
      runner:new_line("if_else.c", { on_line = line, text = "x++;", indent = 8 })
    end
    for _, line in ipairs { 3, 6, 8, 13, 15, 20, 23 } do
      runner:new_line("if_else.c", { on_line = line, text = "else", indent = 4 })
    end
    for _, info in ipairs {
      { 36, 12 },
      { 37, 16 },
      { 38, 12 },
      { 39, 16 },
      { 41, 12 },
      { 42, 8 },
      { 45, 8 },
      { 46, 12 },
      { 47, 16 },
      { 48, 4 },
      { 52, 8 },
      { 53, 12 },
      { 54, 12 },
    } do
      runner:new_line("if_else.c", { on_line = info[1], text = "x++;", indent = info[2] })
    end
    -- dedent braces on new line
    for _, line in ipairs { 10, 12, 14 } do
      runner:new_line("if_else.c", { on_line = line, text = "{}", indent = 4 })
    end

    for _, info in ipairs {
      { 8, 0 },
      { 10, 0 },
      { 13, 4 },
      { 14, 4 },
      { 15, 4 },
      { 16, 4 },
      { 17, 4 },
      { 18, 4 },
      { 20, 8 },
      { 21, 8 },
      { 22, 4 },
    } do
      runner:new_line("issue-4525.c", { on_line = info[1], text = "x++;", indent = info[2] })
    end
  end)
end)

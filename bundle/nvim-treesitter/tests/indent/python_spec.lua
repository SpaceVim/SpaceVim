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
    run:new_line("aligned_indent_2.py", { on_line = 2, text = "x", indent = 4 })
    run:new_line("aligned_indent_2.py", { on_line = 9, text = "x", indent = 4 })
    run:new_line("aligned_indent_2.py", { on_line = 12, text = "x", indent = 4 })
    run:new_line("basic_blocks.py", { on_line = 1, text = "wait,", indent = 4 })
    run:new_line("basic_blocks.py", { on_line = 6, text = "x += 1", indent = 4 })
    run:new_line("basic_blocks.py", { on_line = 7, text = "x += 1", indent = 4 })
    run:new_line("basic_blocks.py", { on_line = 10, text = "x += 1", indent = 8 })
    run:new_line("basic_blocks.py", { on_line = 14, text = "x += 1", indent = 8 })
    run:new_line("basic_collections.py", { on_line = 3, text = "4,", indent = 4 })
    run:new_line("comprehensions.py", { on_line = 8, text = "if x != 2", indent = 4 })
    run:new_line("control_flow.py", { on_line = 2, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 4, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 6, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 9, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 12, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 15, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 18, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 20, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 22, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 24, text = "c < 6 and", indent = 7 })
    run:new_line("control_flow.py", { on_line = 26, text = "x = 4", indent = 4 })
    run:new_line("control_flow.py", { on_line = 28, text = "x = 4", indent = 4 })
    run:new_line("branches.py", { on_line = 25, text = "x > 9 and", indent = 4 })
    run:new_line("branches.py", { on_line = 29, text = "and x > 9", indent = 4 })
    run:new_line("hanging_indent.py", { on_line = 1, text = "arg0,", indent = 4 })
    run:new_line("hanging_indent.py", { on_line = 5, text = "0,", indent = 4 })
    run:new_line("error_state_def.py", { on_line = 6, text = "b,", indent = 11 })
    run:new_line("error_state_tuple.py", { on_line = 7, text = "b,", indent = 1 })
    run:new_line("error_state_tuple_align.py", { on_line = 7, text = "b,", indent = 1 })
    run:new_line("error_state_list.py", { on_line = 5, text = "3,", indent = 6 })
    run:new_line("error_state_dict.py", { on_line = 6, text = "9:10,", indent = 6 })
    run:new_line("error_state_set.py", { on_line = 5, text = "9,", indent = 6 })
    run:new_line("error_state_funcall.py", { on_line = 5, text = "6,", indent = 2 })
    run:new_line("if_else.py", { on_line = 5, text = "else:", indent = 4 })
    run:new_line("if_else.py", { on_line = 5, text = "elif False:", indent = 4 })
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
    run:new_line("line_after_indent.py", { on_line = 4, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 8, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 4, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 14, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 20, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 26, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 30, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 34, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 38, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 42, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 46, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 49, text = "x", indent = 0 })
    run:new_line("line_after_indent.py", { on_line = 55, text = "x", indent = 4 })
    run:new_line("line_after_indent.py", { on_line = 63, text = "x", indent = 4 })
    run:new_line("match_case.py", { on_line = 4, text = "pass", indent = 8 })
    run:new_line("match_case.py", { on_line = 5, text = "pass", indent = 12 })
    run:new_line("match_case.py", { on_line = 10, text = "pass", indent = 8 })
    run:new_line("match_case.py", { on_line = 15, text = "pass", indent = 12 })
    run:new_line("break_continue.py", { on_line = 4, text = "pass", indent = 8 })
    run:new_line("break_continue.py", { on_line = 9, text = "pass", indent = 8 })

    for _, line in ipairs { 2, 5, 8, 11, 16, 21, 24, 27, 34, 39 } do
      run:new_line("return_dedent.py", { on_line = line, text = "x", indent = 0 })
    end
  end)
end)

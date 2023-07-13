local Runner = require("tests.indent.common").Runner
local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent/dart", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  expandtab = true,
})

describe("indent Lua:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {
        "./multiple_arguments.dart",
        "./class.dart",
        "./class_function_argument.dart",
      },
    })
  end)
end)

describe("new line:", function()
  run:new_line("class.dart", { on_line = 4, text = "int five;", indent = 2 })
  run:new_line("class.dart", { on_line = 6, text = "'100'", indent = 8 }, "expected failure", XFAIL)
  run:new_line("class.dart", { on_line = 7, text = "int five = 5", indent = 2 }, "expected failure", XFAIL)
  run:new_line("try.dart", { on_line = 2, text = "var x;", indent = 4 })
  for _, content in ipairs { "var x;", "var x" } do
    run:new_line("try.dart", { on_line = 10, text = content, indent = 6 })
  end
  run:new_line("switch.dart", { on_line = 3, text = "x = 1;", indent = 6 })
  run:new_line("switch.dart", { on_line = 9, text = "x = 1;", indent = 6 })
  run:new_line("switch.dart", { on_line = 3, text = "case 2:", indent = 4 })
  run:new_line("switch.dart", { on_line = 16, text = "abc;", indent = 4 })
  run:new_line("switch.dart", { on_line = 20, text = "abc;", indent = 4 })
  run:new_line("switch.dart", { on_line = 28, text = "y++;", indent = 6 })

  run:new_line("multiple_arguments.dart", { on_line = 10, text = "var x;", indent = 4 })
  run:new_line(
    "multiple_arguments.dart",
    { on_line = 11, text = "var x;", indent = 4 },
    "expected failure issue #4637",
    XFAIL
  )
  run:new_line("class_function_argument.dart", { on_line = 11, text = "}", indent = 4 })
end)

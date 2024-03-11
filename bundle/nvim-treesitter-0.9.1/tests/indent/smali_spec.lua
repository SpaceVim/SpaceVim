local Runner = require("tests.indent.common").Runner

local run = Runner:new(it, "tests/indent/smali", {
  tabstop = 4,
  shiftwidth = 4,
  expandtab = false,
})

describe("indent Smali:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("field.smali", { on_line = 7, text = 'value1 = "test"', indent = 1 })
    run:new_line("field.smali", { on_line = 10, text = "value2 = Lsome/enum;", indent = 2 })
    run:new_line("array_and_switch.smali", { on_line = 43, text = "1 2 3 4 5 6 200", indent = 2 })
    run:new_line("array_and_switch.smali", { on_line = 48, text = "Label10:", indent = 2 })
    run:new_line("method.smali", { on_line = 7, text = ".registers 10", indent = 1 })
    run:new_line("parameter.smali", { on_line = 20, text = ".annotation runtime Lsome/annotation;", indent = 3 })
    run:new_line("parameter.smali", { on_line = 21, text = 'something = "some value"', indent = 3 })
  end)
end)

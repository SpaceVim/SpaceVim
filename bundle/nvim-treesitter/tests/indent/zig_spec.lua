local Runner = require("tests.indent.common").Runner
--local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent/zig", {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
})

describe("indent Zig:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new lines:", function()
    run:new_line("pr-3269.zig", { on_line = 5, text = "return;", indent = 4 })
    run:new_line("pr-3269.zig", { on_line = 6, text = "", indent = 0 })
  end)
end)

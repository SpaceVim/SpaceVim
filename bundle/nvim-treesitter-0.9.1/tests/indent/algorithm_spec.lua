local Runner = require("tests.indent.common").Runner
-- local XFAIL = require("tests.indent.common").XFAIL

local runner = Runner:new(it, "tests/indent/algorithm", {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
})

describe("test indent algorithm: ", function()
  describe("new line:", function()
    runner:new_line("trailing.py", { on_line = 1, text = "x: str", indent = 4 }, "indent next line, ignore comment")
    runner:new_line("trailing.py", { on_line = 4, text = "pass", indent = 8 }, "indent next line, ignore comment")
    runner:new_line("trailing.py", { on_line = 6, text = "pass", indent = 4 }, "indent next line, ignore whitespace")
    runner:new_line("trailing_whitespace.html", { on_line = 9, text = "x", indent = 8 }, "not ignore @indent.end")
  end)
end)

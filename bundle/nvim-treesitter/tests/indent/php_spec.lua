local Runner = require("tests.indent.common").Runner
local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent/php", {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 0,
  expandtab = true,
})

describe("indent PHP:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {
        "./unfinished-call.php",
      },
    })
  end)

  describe("new line:", function()
    run:new_line("example.php", { on_line = 11, text = "// new line starts 1 indentation to far", indent = 4 })
    run:new_line(
      "example2.php",
      { on_line = 5, text = "indendation with `enter` in insert mode is not correct", indent = 4 }
    )
    run:new_line("issue-2497.php", { on_line = 5, text = "$a =", indent = 4 })
    run:new_line("unfinished-call.php", { on_line = 6, text = "$a =", indent = 4 }, "shouldn't be 0", XFAIL)
  end)
end)

local Runner = require("tests.indent.common").Runner
--local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent/r", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 0,
  expandtab = true,
})

describe("indent R:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("comment.R", { on_line = 1, text = "# new comment", indent = 0 })

    run:new_line("cond.R", { on_line = 1, text = "x <- x + 1", indent = 0 })
    run:new_line("cond.R", { on_line = 4, text = "x <- x + 1", indent = 2 })
    run:new_line("cond.R", { on_line = 5, text = "x <- x + 1", indent = 2 })
    run:new_line("cond.R", { on_line = 8, text = "x <- x + 1", indent = 4 })

    run:new_line("func.R", { on_line = 1, text = "x <- x + 1", indent = 2 })
    run:new_line("func.R", { on_line = 2, text = "a <- a + 1", indent = 4 })
    run:new_line("func.R", { on_line = 6, text = "0,", indent = 6 })
    run:new_line("func.R", { on_line = 6, text = "0,", indent = 6 })
    run:new_line("func.R", { on_line = 16, text = "x <- x + 1", indent = 4 })

    run:new_line("loop.R", { on_line = 1, text = "x <- x + 1", indent = 0 })
    run:new_line("loop.R", { on_line = 3, text = "x <- x + 1", indent = 2 })
    run:new_line("loop.R", { on_line = 8, text = "x <- x + 1", indent = 2 })
    run:new_line("loop.R", { on_line = 14, text = "print('lol')", indent = 4 })

    run:new_line("pipe.R", { on_line = 1, text = "head(n = 10L) |>", indent = 2 })
    run:new_line("pipe.R", { on_line = 9, text = "head()", indent = 2 })

    run:new_line("aligned_indent.R", { on_line = 1, text = "z,", indent = 17 })
  end)
end)

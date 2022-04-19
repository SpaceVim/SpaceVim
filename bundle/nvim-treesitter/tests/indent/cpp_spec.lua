local Runner = require("tests.indent.common").Runner
local XFAIL = require("tests.indent.common").XFAIL

-- will use both c/ and cpp/
local run = Runner:new(it, "tests/indent", {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 0,
  expandtab = true,
  filetype = "cpp",
})

describe("indent C++:", function()
  describe("whole file:", function()
    run:whole_file({ "c/", "cpp/" }, {
      expected_failures = {
        -- C
        "c/preproc_func.c",
        "c/unfinished_comment.c",
      },
    })
  end)

  describe("new line:", function()
    run:new_line("cpp/access.cpp", { on_line = 3, text = "protected:", indent = 0 })
    run:new_line("cpp/class.cpp", { on_line = 2, text = "using T = int;", indent = 4 })
    run:new_line("cpp/stream.cpp", { on_line = 5, text = "<< x + 3", indent = 8 })

    -- TODO: find a clean way to import these from c_spec.lua
    run:new_line("c/array.c", { on_line = 2, text = "0,", indent = 4 })
    run:new_line("c/cond.c", { on_line = 3, text = "x++;", indent = 8 })
    run:new_line("c/cond.c", { on_line = 6, text = "x++;", indent = 8 })
    run:new_line("c/cond.c", { on_line = 8, text = "x++;", indent = 8 })
    run:new_line("c/cond.c", { on_line = 9, text = "x++;", indent = 4 })
    run:new_line("c/expr.c", { on_line = 10, text = "2 *", indent = 8 })
    run:new_line("c/func.c", { on_line = 17, text = "int z,", indent = 4 })
    run:new_line("c/label.c", { on_line = 3, text = "normal:", indent = 0 })
    run:new_line("c/loop.c", { on_line = 3, text = "x++;", indent = 8 })
    run:new_line("c/preproc_cond.c", { on_line = 5, text = "x++;", indent = 4 })
    run:new_line("c/preproc_func.c", { on_line = 3, text = "x++; \\", indent = 8 }, "expected failure", XFAIL)
    run:new_line("c/string.c", { on_line = 1, text = "brave new \\", indent = 0 })
    run:new_line("c/string.c", { on_line = 4, text = '"brave new "', indent = 4 })
    run:new_line("c/struct.c", { on_line = 4, text = "int y;", indent = 8 })
    run:new_line("c/switch.c", { on_line = 3, text = "x++;", indent = 12 })
    run:new_line("c/ternary.c", { on_line = 4, text = ": (x == 0) : 0", indent = 8 })
    -- the line after inserted one will be left with wrong indent but we only care about the inserted one
    run:new_line("c/no_braces.c", { on_line = 4, text = "x++;", indent = 8 })
    run:new_line("c/no_braces.c", { on_line = 7, text = "x++;", indent = 8 })
    run:new_line("c/no_braces.c", { on_line = 10, text = "x++;", indent = 8 })
  end)
end)

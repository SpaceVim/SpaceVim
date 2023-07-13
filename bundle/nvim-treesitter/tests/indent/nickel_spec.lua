local Runner = require("tests.indent.common").Runner

local run = Runner:new(it, "tests/indent/nickel", {
  shiftwidth = 2,
  expandtab = true,
})

describe("indent Nickel:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("indent-newline.ncl", { on_line = 1, text = "stmt", indent = 2 })
    run:new_line("indent-newline.ncl", { on_line = 2, text = "stmt", indent = 2 })
    run:new_line("indent-newline.ncl", { on_line = 3, text = "stmt", indent = 4 })
    run:new_line("indent-newline.ncl", { on_line = 4, text = "]", indent = 2 })
    run:new_line("indent-newline.ncl", { on_line = 5, text = "stmt", indent = 2 })
    run:new_line("indent-newline.ncl", { on_line = 6, text = "stmt", indent = 4 })
    run:new_line("indent-newline.ncl", { on_line = 7, text = "}", indent = 2 })
    run:new_line("indent-newline.ncl", { on_line = 11, text = "stmt", indent = 0 })
  end)
end)

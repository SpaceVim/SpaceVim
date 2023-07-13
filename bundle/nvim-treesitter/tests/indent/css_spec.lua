local Runner = require("tests.indent.common").Runner

local run = Runner:new(it, "tests/indent/css", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 0,
  expandtab = true,
})

describe("indent CSS:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("open_block.css", { on_line = 1, text = "}", indent = 0 })
    run:new_line("open_block.css", { on_line = 1, text = "color: green;", indent = 2 })
    run:new_line("next_rule.css", { on_line = 3, text = ".next {", indent = 0 })
  end)
end)

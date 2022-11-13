local Runner = require("tests.indent.common").Runner

local run = Runner:new(it, "tests/indent/ruby", {
  shiftwidth = 2,
  expandtab = true,
})

describe("indent Ruby:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = { "./period-issue-3364.rb" },
    })
  end)

  describe("new line:", function()
    run:new_line("indent-unless.rb", { on_line = 1, text = "stmt", indent = 2 })
    run:new_line("indent-assignment.rb", { on_line = 1, text = "1 +", indent = 2 })
    run:new_line("indent-parenthesized-statements.rb", { on_line = 1, text = "stmt", indent = 2 })
  end)
end)

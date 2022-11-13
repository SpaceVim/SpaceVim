local Runner = require("tests.indent.common").Runner
--local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent/hcl", {
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
})

describe("indent HCL:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("no-indent-after-brace.tf", { on_line = 4, text = "# Wow, no indent here please", indent = 0 })
    run:new_line("indent-in-multiline-tuples.tf", { on_line = 4, text = "3,", indent = 4 })
    run:new_line("indent-in-multiline-tuples.tf", { on_line = 3, text = "# as elements", indent = 4 })
    run:new_line("indent-in-multiline-tuples.tf", { on_line = 5, text = "# as outer block", indent = 2 })
    run:new_line("indent-in-multiline-tuples.tf", { on_line = 1, text = "# as outer block", indent = 2 })
    run:new_line("indent-in-multiline-objects.tf", { on_line = 4, text = '3: "baz",', indent = 4 })
    run:new_line("indent-in-multiline-objects.tf", { on_line = 3, text = "# as elements", indent = 4 })
    run:new_line("indent-in-multiline-objects.tf", { on_line = 5, text = "# as outer block", indent = 2 })
    run:new_line("indent-in-multiline-objects.tf", { on_line = 1, text = "# as outer block", indent = 2 })
    run:new_line("multiple-attributes.tf", { on_line = 2, text = "a = 1", indent = 2 })
    run:new_line("multiple-attributes.tf", { on_line = 3, text = "a = 1", indent = 2 })
    run:new_line("multiple-attributes.tf", { on_line = 4, text = "a = 1", indent = 0 })
    run:new_line("nested_blocks.tf", { on_line = 3, text = "a = 1", indent = 4 })
    run:new_line("nested_blocks.tf", { on_line = 4, text = "a = 1", indent = 2 })
    run:new_line("function_call.tf", { on_line = 4, text = "c,", indent = 4 })
    run:new_line("function_call.tf", { on_line = 5, text = "a = 1", indent = 2 })
  end)
end)

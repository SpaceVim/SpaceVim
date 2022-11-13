local Runner = require("tests.indent.common").Runner
--local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent/yaml", {
  shiftwidth = 2,
  expandtab = true,
})

describe("indent YAML:", function()
  describe("whole file:", function()
    run:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    run:new_line("indent-sequence-items.yaml", { on_line = 2, text = "key3: value3", indent = 2 })
    run:new_line("autoindent-mapping-pair.yaml", { on_line = 1, text = "key3: value3", indent = 2 })
  end)
end)

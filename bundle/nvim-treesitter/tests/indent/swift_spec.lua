local Runner = require("tests.indent.common").Runner

local run = Runner:new(it, "tests/indent/swift", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  expandtab = true,
})

describe("indent Swift:", function()
  describe("whole file:", function()
    run:whole_file(".", {})
  end)
  describe("new line:", function()
    run:new_line("declarations.swift", { on_line = 6, text = "var x = 1", indent = 2 })
    run:new_line("declarations.swift", { on_line = 12, text = "var textInsideInit = true", indent = 4 })
    run:new_line("declarations.swift", { on_line = 17, text = "var textInsideWillSet = 1", indent = 6 })
    run:new_line("declarations.swift", { on_line = 22, text = "var textInsideOverrideFunc", indent = 4 })
    run:new_line("declarations.swift", { on_line = 28, text = "var InsideProtocol: String { get }", indent = 2 })
  end)
end)

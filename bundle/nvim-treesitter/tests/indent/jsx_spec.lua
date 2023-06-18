local Runner = require("tests.indent.common").Runner
local runner = Runner:new(it, "tests/indent/jsx", {
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  filetype = "jsx",
})

describe("indent JSX Elements:", function()
  describe("whole file:", function()
    runner:whole_file(".", {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    for _, info in ipairs {
      { 5, 8 },
      { 6, 6 },
      { 7, 6 },
      { 8, 4 },
      { 9, 2 },
    } do
      runner:new_line("issue-3986.jsx", { on_line = info[1], text = "text", indent = info[2] })
    end
    for _, info in ipairs {
      { 4, 8 },
      { 6, 10 },
      { 9, 8 },
      { 11, 8 },
    } do
      runner:new_line("element_attributes.jsx", { on_line = info[1], text = "disabled", indent = info[2] })
    end

    for _, info in ipairs {
      { 5, 10 },
      { 7, 8 },
      { 11, 10 },
    } do
      runner:new_line("jsx_expression.jsx", { on_line = info[1], text = "{disabled}", indent = info[2] })
    end
  end)
end)

local Runner = require("tests.indent.common").Runner
-- local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 0,
  expandtab = true,
  filetype = "javascript",
})

describe("indent JavaScript:", function()
  describe("whole file:", function()
    run:whole_file({ "ecma/" }, {
      expected_failures = {},
    })
  end)

  describe("new line:", function()
    for _, info in ipairs {
      { 1, 2 },
      { 2, 4 },
      { 3, 4 },
    } do
      run:new_line("ecma/binary_expression.js", { on_line = info[1], text = "//", indent = info[2] }, info[3], info[4])
    end

    run:new_line("ecma/new-line-after-class.js", { on_line = 2, text = "", indent = 0 })

    for _, info in ipairs {
      { 4, 2 },
      { 6, 0 },
    } do
      run:new_line("ecma/callback.js", { on_line = info[1], text = "//", indent = info[2] }, info[3], info[4])
    end

    for _, info in ipairs {
      { 1, 2 },
      { 2, 4 },
      { 3, 6 },
      { 5, 4 },
      { 8, 2 },
      { 11, 4 },
      { 13, 4 },
    } do
      run:new_line("ecma/class.js", { on_line = info[1], text = "//", indent = info[2] }, info[3], info[4])
    end

    for _, info in ipairs {
      { 2, 2 },
      { 5, 2 },
      { 7, 0 },
      { 12, 4 },
      { 18, 2 },
      { 19, 2 },
      { 20, 2 },
      { 25, 2 },
      { 42, 8 },
      { 43, 10 },
      { 44, 12 },
      { 48, 4 },
      { 49, 4 },
      { 50, 2 },
    } do
      run:new_line("ecma/func.js", { on_line = info[1], text = "//", indent = info[2] }, info[3], info[4])
    end

    for _, info in ipairs {
      { 1, 2 },
      { 2, 2 },
      { 3, 2 },
      { 5, 4 },
      { 6, 4 },
      { 8, 2 },
      { 9, 2 },
      { 12, 2 },
      { 13, 0 },
    } do
      run:new_line("ecma/if_else.js", { on_line = info[1], text = "hello()", indent = info[2] }, info[3], info[4])
    end

    for _, info in ipairs {
      { 2, 2 },
      { 5, 0 },
    } do
      run:new_line("ecma/object.js", { on_line = info[1], text = "//", indent = info[2] }, info[3], info[4])
    end

    for _, info in ipairs {
      { 3, 6 },
      { 4, 6 },
    } do
      run:new_line("ecma/ternary.js", { on_line = info[1], text = "//", indent = info[2] }, info[3], info[4])
    end

    for _, info in ipairs {
      { 1, 2 },
      { 2, 2 },
      { 3, 2 },
      { 4, 2 },
      { 5, 2 },
      { 6, 2 },
      { 7, 0 },
    } do
      run:new_line("ecma/try_catch.js", { on_line = info[1], text = "hello()", indent = info[2] }, info[3], info[4])
    end

    for _, info in ipairs {
      { 1, 2 },
      { 2, 0 },
    } do
      run:new_line("ecma/variable.js", { on_line = info[1], text = "hello()", indent = info[2] }, info[3], info[4])
    end

    for _, line in ipairs { 2, 6 } do
      run:new_line("ecma/issue-2515.js", { on_line = line, text = "{}", indent = 4 })
    end

    for _, info in ipairs { { line = 2, indent = 0 } } do
      run:new_line("ecma/array-issue3382.js", { on_line = info.line, text = "foo();", indent = info.indent })
    end
  end)
end)

local Runner = require("tests.indent.common").Runner
local XFAIL = require("tests.indent.common").XFAIL

local runner = Runner:new(it, "tests/indent/t32", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 0,
  expandtab = true,
})

describe("indent t32:", function()
  describe("whole file:", function()
    runner:whole_file "."
  end)

  describe("new line:", function()
    runner:new_line("if_block.cmm", { on_line = 2, text = "GOTO start", indent = 0 }, "command after IF", XFAIL)

    runner:new_line("if_block.cmm", { on_line = 5, text = "GOTO start", indent = 2 }, "command in IF then block")

    runner:new_line("if_block.cmm", { on_line = 4, text = "(", indent = 0 }, "block after IF")

    for ii, test in ipairs {
      { 1, 2 },
      { 14, 2 },
      { 19, 2 },
      { 21, 2 },
      { 41, 2 },
      { 42, 4 },
    } do
      runner:new_line(
        "if_block.cmm",
        { on_line = test[1], text = "&x=1.", indent = test[2] },
        "command in IF then[" .. ii .. "]"
      )
    end

    runner:new_line("if_block.cmm", { on_line = 45, text = "&x=1.", indent = 2 }, "command in IF then")

    for ii, test in ipairs {
      { 16, 2 },
      { 21, 2 },
      { 23, 2 },
      { 44, 4 },
    } do
      runner:new_line(
        "if_block.cmm",
        { on_line = test[1], text = "(\n", indent = test[2] },
        "command in IF else[" .. ii .. "]"
      )
    end

    runner:new_line("while_block.cmm", { on_line = 2, text = "&x=1.", indent = 2 }, "command after WHILE")

    runner:new_line("while_block.cmm", { on_line = 4, text = "&x=1.", indent = 0 }, "command after WHILE")

    runner:new_line("while_block.cmm", { on_line = 1, text = "(\n", indent = 0 }, "block in WHILE then")

    for ii, test in ipairs {
      { 5, 2 },
      { 12, 2 },
    } do
      runner:new_line(
        "while_block.cmm",
        { on_line = test[1], text = "&x=1.", indent = test[2] },
        "command in WHILE then block[" .. ii .. "]"
      )
    end

    for ii, test in ipairs {
      { 1, 0, nil },
      { 4, 2, XFAIL },
    } do
      runner:new_line(
        "repeat_block.cmm",
        { on_line = test[1], text = "&x=1.", indent = test[2] },
        "command after RePeaT[" .. ii .. "]"
      )
    end

    runner:new_line("repeat_block.cmm", { on_line = 3, text = "(\n", indent = 0 }, "block in RePeaT then")

    for ii, test in ipairs {
      { 7, 2, XFAIL },
      { 18, 2, nil },
      { 24, 2, XFAIL },
    } do
      runner:new_line(
        "repeat_block.cmm",
        { on_line = test[1], text = "&x=1.", indent = test[2] },
        "command in RePeaT then block [" .. ii .. "]"
      )
    end

    runner:new_line("subroutine_block.cmm", { on_line = 1, text = "(\n", indent = 0 }, "block after call label")

    for ii, test in ipairs {
      { 2, 2, XFAIL },
      { 3, 2, nil },
      { 8, 2, XFAIL },
      { 12, 2, nil },
      { 19, 2, XFAIL },
    } do
      runner:new_line(
        "subroutine_block.cmm",
        { on_line = test[1], text = "&x=1.", indent = test[2] },
        "command in subroutine block[" .. ii .. "]"
      )
    end

    for ii, test in ipairs {
      { 5, 2 },
      { 13, 2 },
      { 23, 2 },
    } do
      runner:new_line(
        "subroutine_block.cmm",
        { on_line = test[1], text = "&x=1.", indent = test[2] },
        "command after subroutine block[" .. ii .. "]"
      )
    end
  end)
end)

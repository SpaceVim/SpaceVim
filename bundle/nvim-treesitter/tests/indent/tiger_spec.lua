local Runner = require("tests.indent.common").Runner

local runner = Runner:new(it, "tests/indent/tiger", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 0,
  expandtab = true,
})

describe("indent Tiger:", function()
  describe("whole file:", function()
    runner:whole_file "."
  end)

  describe("new line:", function()
    runner:new_line("classes.tig", { on_line = 1, text = "var a := 0", indent = 2 }, "class declaration beginning")
    runner:new_line("classes.tig", { on_line = 2, text = "var a := 0", indent = 2 }, "class declaration after field")
    runner:new_line("classes.tig", { on_line = 4, text = "var a := 0", indent = 2 }, "class declaration after method")
    runner:new_line("classes.tig", { on_line = 5, text = "var a := 0", indent = 0 }, "after class declaration")
    runner:new_line("classes.tig", { on_line = 7, text = "var a := 0", indent = 2 }, "class type beginning")
    runner:new_line("classes.tig", { on_line = 8, text = "var a := 0", indent = 2 }, "class type after field")
    runner:new_line("classes.tig", { on_line = 10, text = "self.a := 0", indent = 4 }, "inside method")
    runner:new_line("classes.tig", { on_line = 13, text = "var a := 0", indent = 2 }, "class type after method")
    runner:new_line("classes.tig", { on_line = 14, text = "var a := 0", indent = 0 }, "after class type")

    runner:new_line("control-flow.tig", { on_line = 2, text = "true", indent = 4 }, "if condition")
    runner:new_line("control-flow.tig", { on_line = 4, text = "true", indent = 4 }, "if consequence")
    runner:new_line("control-flow.tig", { on_line = 4, text = "true", indent = 4 }, "if alternative")
    runner:new_line("control-flow.tig", { on_line = 10, text = "start := 0", indent = 4 }, "for index start")
    runner:new_line("control-flow.tig", { on_line = 12, text = "the_end", indent = 4 }, "for index end")
    runner:new_line("control-flow.tig", { on_line = 14, text = "break", indent = 4 }, "for body")
    runner:new_line("control-flow.tig", { on_line = 18, text = "true", indent = 4 }, "while condition")
    runner:new_line("control-flow.tig", { on_line = 20, text = "break", indent = 4 }, "while body")

    runner:new_line("functions.tig", { on_line = 1, text = "parameter: int,", indent = 2 }, "parameter list beginning")
    runner:new_line("functions.tig", { on_line = 2, text = "parameter: int,", indent = 2 }, "parameter list middle")
    runner:new_line("functions.tig", { on_line = 4, text = ",parameter: int", indent = 2 }, "parameter list end")
    runner:new_line("functions.tig", { on_line = 5, text = "var a := 0", indent = 0 }, "after parameter list")
    runner:new_line("functions.tig", { on_line = 7, text = "print(a)", indent = 2 }, "function body")
    runner:new_line("functions.tig", { on_line = 9, text = "a,", indent = 6 }, "function call beginning")
    runner:new_line("functions.tig", { on_line = 10, text = "a,", indent = 6 }, "function call middle")
    runner:new_line("functions.tig", { on_line = 12, text = ",a", indent = 6 }, "function call end")
    runner:new_line("functions.tig", { on_line = 13, text = "; print(a)", indent = 4 }, "after function call")
    runner:new_line("functions.tig", { on_line = 14, text = "var a := 12", indent = 0 }, "after function declaration")

    runner:new_line("groupings.tig", { on_line = 2, text = "var b := 0", indent = 2 }, "let declarations")
    runner:new_line("groupings.tig", { on_line = 3, text = "a := a + 1", indent = 2 }, "after 'in'")
    runner:new_line("groupings.tig", { on_line = 4, text = "a := a + 1;", indent = 4 }, "sequence")
    runner:new_line("groupings.tig", { on_line = 8, text = "a := a + 1;", indent = 2 }, "after sequence")
    runner:new_line("groupings.tig", { on_line = 10, text = "+ 1", indent = 0 }, "after 'end'")

    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 4, text = "field: record,", indent = 4 },
      "record type beginning"
    )
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 5, text = "field: record,", indent = 4 },
      "record type middle"
    )
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 7, text = ",field: record", indent = 4 },
      "record type end"
    )
    runner:new_line("values-and-expressions.tig", { on_line = 8, text = "var a := 0", indent = 2 }, "after record type")
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 10, text = "0", indent = 4 },
      "variable declaration init value"
    )
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 11, text = "+ a", indent = 4 },
      "variable declaration init follow-up"
    )
    runner:new_line("values-and-expressions.tig", { on_line = 13, text = "a", indent = 4 }, "array index")
    runner:new_line("values-and-expressions.tig", { on_line = 14, text = "+ a", indent = 4 }, "array index follow-up")
    runner:new_line("values-and-expressions.tig", { on_line = 15, text = "+ a", indent = 2 }, "after array value")
    runner:new_line("values-and-expressions.tig", { on_line = 18, text = "a", indent = 4 }, "array expression size")
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 20, text = "of", indent = 4 },
      "array expression after size"
    )
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 21, text = "a", indent = 4 },
      "array expression init value"
    )
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 25, text = "field = 0,", indent = 4 },
      "record expression beginning"
    )
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 26, text = "field = 0,", indent = 4 },
      "record expression middle"
    )
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 28, text = ",field = 0", indent = 4 },
      "record expression end"
    )
    runner:new_line(
      "values-and-expressions.tig",
      { on_line = 29, text = "a := 0", indent = 2 },
      "after record expression"
    )
  end)
end)

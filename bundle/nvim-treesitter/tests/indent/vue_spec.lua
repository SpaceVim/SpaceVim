local Runner = require("tests.indent.common").Runner
-- local XFAIL = require("tests.indent.common").XFAIL

local run = Runner:new(it, "tests/indent", {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 0,
  expandtab = true,
})

describe("indent Vue:", function()
  describe("whole file:", function()
    run:whole_file({ "vue/" }, {})
  end)

  describe("new line:", function()
    for _, info in ipairs {
      { 1, 2 },
      { 3, 0 },
    } do
      run:new_line("vue/template_indent.vue", { on_line = info[1], text = "Foo", indent = info[2] }, info[3], info[4])
    end
  end)
end)

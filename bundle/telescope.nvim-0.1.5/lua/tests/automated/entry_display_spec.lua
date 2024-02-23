local entry_display = require "telescope.pickers.entry_display"

describe("truncate", function()
  for _, ambiwidth in ipairs { "single", "double" } do
    for _, case in ipairs {
      { args = { "abcde", 6 }, expected = { single = "abcde", double = "abcde" } },
      { args = { "abcde", 5 }, expected = { single = "abcde", double = "abcde" } },
      { args = { "abcde", 4 }, expected = { single = "abc…", double = "ab…" } },
      { args = { "アイウエオ", 11 }, expected = { single = "アイウエオ", double = "アイウエオ" } },
      { args = { "アイウエオ", 10 }, expected = { single = "アイウエオ", double = "アイウエオ" } },
      { args = { "アイウエオ", 9 }, expected = { single = "アイウエ…", double = "アイウ…" } },
      { args = { "アイウエオ", 8 }, expected = { single = "アイウ…", double = "アイウ…" } },
      { args = { "├─┤", 7 }, expected = { single = "├─┤", double = "├─┤" } },
      { args = { "├─┤", 6 }, expected = { single = "├─┤", double = "├─┤" } },
      { args = { "├─┤", 5 }, expected = { single = "├─┤", double = "├…" } },
      { args = { "├─┤", 4 }, expected = { single = "├─┤", double = "├…" } },
      { args = { "├─┤", 3 }, expected = { single = "├─┤", double = "…" } },
      { args = { "├─┤", 2 }, expected = { single = "├…", double = "…" } },
    } do
      local msg = ("can truncate: ambiwidth = %s, [%s, %d] -> %s"):format(
        ambiwidth,
        case.args[1],
        case.args[2],
        case.expected[ambiwidth]
      )
      it(msg, function()
        local original = vim.o.ambiwidth
        vim.o.ambiwidth = ambiwidth
        assert.are.same(case.expected[ambiwidth], entry_display.truncate(case.args[1], case.args[2]))
        vim.o.ambiwidth = original
      end)
    end
  end
end)

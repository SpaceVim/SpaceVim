local stub = require "luassert.stub"
local parsers = require "nvim-treesitter.parsers"

describe("maintained_parsers", function()
  before_each(function()
    stub(vim.fn, "executable")
  end)

  after_each(function()
    vim.fn.executable:clear()
  end)

  it("does not return experimental parsers", function()
    local old_list = parsers.list
    parsers.list = {
      c = {
        install_info = {
          url = "https://github.com/tree-sitter/tree-sitter-c",
          files = { "src/parser.c" },
        },
        maintainers = { "@vigoux" },
      },
      d = {
        install_info = {
          url = "https://github.com/CyberShadow/tree-sitter-d",
          files = { "src/parser.c", "src/scanner.cc" },
          requires_generate_from_grammar = true,
        },
        maintainers = { "@nawordar" },
        experimental = true,
      },
      haskell = {
        install_info = {
          url = "https://github.com/tree-sitter/tree-sitter-haskell",
          files = { "src/parser.c", "src/scanner.cc" },
        },
      },
    }

    local expected = { "c" }

    assert.same(parsers.maintained_parsers(), expected)

    parsers.list = old_list
  end)
end)

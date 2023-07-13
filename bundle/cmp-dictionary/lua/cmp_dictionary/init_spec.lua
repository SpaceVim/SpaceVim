local main = require("cmp_dictionary")

local function dictionary()
  return vim.opt_local.dictionary:get()
end

describe("Test for init.lua", function()
  before_each(function()
    vim.opt_local.dictionary = {}
  end)

  describe("switcher", function()
    describe("filetype", function()
      it("single dictionary", function()
        main.switcher({
          filetype = {
            lua = "/path/to/lua.dict",
          },
        })
        vim.opt.filetype = "lua"
        assert.are.same({ "/path/to/lua.dict" }, dictionary())
      end)
      it("multi dictionaries", function()
        main.switcher({
          filetype = {
            javascript = { "/path/to/js.dict", "/path/to/js2.dict" },
          },
        })
        vim.opt.filetype = "javascript"
        assert.are.same({ "/path/to/js.dict", "/path/to/js2.dict" }, dictionary())
      end)
    end)
  end)
end)

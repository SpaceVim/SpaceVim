pcall(require, "luacov")

local Text = require("nui.text")
local h = require("tests.helpers")
local spy = require("luassert.spy")

local eq, tbl_omit = h.eq, h.tbl_omit

describe("nui.text", function()
  local multibyte_char

  before_each(function()
    multibyte_char = "║"
  end)

  it("can clone nui.text object", function()
    local hl_group = "NuiTextTest"

    local t1 = Text("42", hl_group)

    t1.extmark.id = 42
    local t2 = Text(t1)
    eq(t2:content(), t1:content())
    eq(t2.extmark, tbl_omit(t1.extmark, { "id" }))

    t2.extmark.id = 42
    local t3 = Text(t2)
    eq(t3:content(), t2:content())
    eq(t3.extmark, tbl_omit(t2.extmark, { "id" }))
  end)

  it("can clone nui.text object overriding extmark", function()
    local hl_group = "NuiTextTest"
    local hl_group_override = "NuiTextTestOverride"

    local t1 = Text("42", hl_group)

    t1.extmark.id = 42
    local t2 = Text(t1, hl_group_override)
    eq(t2:content(), t1:content())
    eq(t2.extmark, { hl_group = hl_group_override })

    local t3 = Text(t2, { id = 42, hl_group = hl_group })
    eq(t3:content(), t2:content())
    eq(t3.extmark, { hl_group = hl_group })
  end)

  describe("method :set", function()
    it("works", function()
      local hl_group = "NuiTextTest"
      local hl_group_override = "NuiTextTestOverride"

      local text = Text("42", hl_group)

      eq(text:content(), "42")
      eq(text:length(), 2)
      eq(text.extmark, {
        hl_group = hl_group,
      })

      text.extmark.id = 42

      text:set("3")
      eq(text:content(), "3")
      eq(text:length(), 1)
      eq(text.extmark, {
        hl_group = hl_group,
        id = 42,
      })

      text:set("9", hl_group_override)
      eq(text:content(), "9")
      eq(text.extmark, {
        hl_group = hl_group_override,
        id = 42,
      })

      text:set("11", { hl_group = hl_group })
      eq(text:content(), "11")
      eq(text.extmark, {
        hl_group = hl_group,
        id = 42,
      })

      text.extmark.id = nil

      text:set("42", { id = 42, hl_group = hl_group })
      eq(text:content(), "42")
      eq(text.extmark, { hl_group = hl_group })
    end)
  end)

  describe("method :content", function()
    it("works", function()
      local content = "42"
      local text = Text(content)
      eq(text:content(), content)

      local multibyte_content = multibyte_char
      local multibyte_text = Text(multibyte_content)
      eq(multibyte_text:content(), multibyte_content)
    end)
  end)

  describe("method :length", function()
    it("works", function()
      local content = "42"
      local text = Text(content)
      eq(text:length(), 2)
      eq(text:length(), vim.fn.strlen(content))

      local multibyte_content = multibyte_char
      local multibyte_text = Text(multibyte_content)
      eq(multibyte_text:length(), 3)
      eq(multibyte_text:length(), vim.fn.strlen(multibyte_content))
    end)
  end)

  describe("method :width", function()
    it("works", function()
      local content = "42"
      local text = Text(content)
      eq(text:width(), 2)
      eq(text:width(), vim.fn.strwidth(content))

      local multibyte_content = multibyte_char
      local multibyte_text = Text(multibyte_content)
      eq(multibyte_text:width(), 1)
      eq(multibyte_text:width(), vim.fn.strwidth(multibyte_content))
    end)
  end)

  describe("method", function()
    local winid, bufnr
    local initial_lines

    before_each(function()
      winid = vim.api.nvim_get_current_win()
      bufnr = vim.api.nvim_create_buf(false, true)

      vim.api.nvim_win_set_buf(winid, bufnr)

      initial_lines = { "  1", multibyte_char .. " 2", "  3" }
    end)

    after_each(function()
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)

    local function reset_lines(lines)
      initial_lines = lines or initial_lines
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, initial_lines)
    end

    describe(":highlight", function()
      local hl_group, ns, ns_id
      local linenr, byte_start
      local text

      before_each(function()
        hl_group = "NuiTextTest"
        ns = "NuiTest"
        ns_id = vim.api.nvim_create_namespace(ns)
      end)

      it("is applied with :render", function()
        reset_lines()
        linenr, byte_start = 1, 0
        text = Text("a", hl_group)
        text:render(bufnr, ns_id, linenr, byte_start)
        h.assert_highlight(bufnr, ns_id, linenr, text:content(), hl_group)
      end)

      it("is applied with :render_char", function()
        reset_lines()
        linenr, byte_start = 1, 0
        text = Text(multibyte_char, hl_group)
        text:render_char(bufnr, ns_id, linenr, byte_start)
        h.assert_highlight(bufnr, ns_id, linenr, text:content(), hl_group)
      end)

      it("can highlight existing buffer text", function()
        reset_lines()
        linenr, byte_start = 2, 0
        text = Text(initial_lines[linenr], hl_group)
        text:highlight(bufnr, ns_id, linenr, byte_start)
        h.assert_highlight(bufnr, ns_id, linenr, text:content(), hl_group)
      end)

      it("does not create multiple extmarks", function()
        reset_lines()
        linenr, byte_start = 2, 0
        text = Text(initial_lines[linenr], hl_group)

        text:highlight(bufnr, ns_id, linenr, byte_start)
        h.assert_highlight(bufnr, ns_id, linenr, text:content(), hl_group)
        text:highlight(bufnr, ns_id, linenr, byte_start)
        h.assert_highlight(bufnr, ns_id, linenr, text:content(), hl_group)
        text:highlight(bufnr, ns_id, linenr, byte_start)
        h.assert_highlight(bufnr, ns_id, linenr, text:content(), hl_group)
      end)
    end)

    describe(":render", function()
      it("works on line with singlebyte characters", function()
        reset_lines()

        local text = Text("a")

        spy.on(text, "highlight")

        text:render(bufnr, -1, 1, 1)

        assert.spy(text.highlight).was_called(1)
        assert.spy(text.highlight).was_called_with(text, bufnr, -1, 1, 1)

        h.assert_buf_lines(bufnr, {
          " a1",
          initial_lines[2],
          initial_lines[3],
        })
      end)

      it("works on line with multibyte characters", function()
        reset_lines()

        local text = Text("a")

        spy.on(text, "highlight")

        text:render(bufnr, -1, 2, vim.fn.strlen(multibyte_char))

        assert.spy(text.highlight).was_called(1)
        assert.spy(text.highlight).was_called_with(text, bufnr, -1, 2, vim.fn.strlen(multibyte_char))

        h.assert_buf_lines(bufnr, {
          initial_lines[1],
          multibyte_char .. "a2",
          initial_lines[3],
        })
      end)
    end)

    describe(":render_char", function()
      it("works on line with singlebyte characters", function()
        reset_lines()

        local text = Text("a")

        spy.on(text, "highlight")

        text:render_char(bufnr, -1, 1, 1)

        assert.spy(text.highlight).was_called(1)
        assert.spy(text.highlight).was_called_with(text, bufnr, -1, 1, 1)

        h.assert_buf_lines(bufnr, {
          " a1",
          initial_lines[2],
          initial_lines[3],
        })
      end)

      it("works on line with multibyte characters", function()
        reset_lines()

        local text = Text("a")

        spy.on(text, "highlight")

        text:render_char(bufnr, -1, 2, 1)

        assert.spy(text.highlight).was_called(1)
        assert.spy(text.highlight).was_called_with(text, bufnr, -1, 2, vim.fn.strlen(multibyte_char))

        h.assert_buf_lines(bufnr, {
          initial_lines[1],
          multibyte_char .. "a2",
          initial_lines[3],
        })
      end)
    end)
  end)
end)

pcall(require, "luacov")

local Menu = require("nui.menu")
local Line = require("nui.line")
local Text = require("nui.text")
local h = require("tests.helpers")
local spy = require("luassert.spy")

local eq, feedkeys = h.eq, h.feedkeys

describe("nui.menu", function()
  local callbacks
  local popup_options
  local menu

  before_each(function()
    callbacks = {
      on_change = function() end,
      on_submit = function() end,
    }

    popup_options = {
      relative = "win",
      position = "50%",
    }
  end)

  after_each(function()
    if menu then
      menu:unmount()
      menu = nil
    end
  end)

  describe("method :new", function()
    it("works with menu", function()
      menu = Menu:new(popup_options, {
        lines = {
          Menu.item("a"),
        },
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        "a",
      })
    end)
  end)

  describe("o.keymap", function()
    it("supports multiple keys as table", function()
      local on_change = spy.on(callbacks, "on_change")

      local lines = {
        Menu.item("Item 1", { id = 1 }),
        Menu.item("Item 2", { id = 2 }),
        Menu.item("Item 3", { id = 3 }),
      }

      menu = Menu(popup_options, {
        keymap = {
          focus_next = { "j", "s" },
          focus_prev = { "k", "w" },
        },
        lines = lines,
        on_change = on_change,
      })

      menu:mount()

      feedkeys("j", "x")
      assert.spy(on_change).called_with(lines[2], menu)
      on_change:clear()

      feedkeys("s", "x")
      assert.spy(on_change).called_with(lines[3], menu)
      on_change:clear()

      feedkeys("w", "x")
      assert.spy(on_change).called_with(lines[2], menu)
      on_change:clear()

      feedkeys("k", "x")
      assert.spy(on_change).called_with(lines[1], menu)
      on_change:clear()
    end)

    it("supports single key as string", function()
      local on_change = spy.on(callbacks, "on_change")

      local lines = {
        Menu.item("Item 1", { id = 1 }),
        Menu.item("Item 2", { id = 2 }),
        Menu.item("Item 3", { id = 3 }),
      }

      menu = Menu(popup_options, {
        keymap = {
          focus_next = "s",
          focus_prev = "w",
        },
        lines = lines,
        on_change = on_change,
      })

      menu:mount()

      feedkeys("s", "x")
      assert.spy(on_change).called_with(lines[2], menu)
      on_change:clear()

      feedkeys("w", "x")
      assert.spy(on_change).called_with(lines[1], menu)
      on_change:clear()
    end)
  end)

  describe("size", function()
    it("respects o.min_width", function()
      local min_width = 3

      local items = {
        Menu.item("A"),
        Menu.separator("*"),
        Menu.item("B"),
      }

      menu = Menu(popup_options, {
        lines = items,
        min_width = min_width,
      })

      menu:mount()

      eq(vim.api.nvim_win_get_width(menu.winid), min_width)

      h.assert_buf_lines(menu.bufnr, {
        "A",
        " * ",
        "B",
      })
    end)

    it("respects o.max_width", function()
      local max_width = 6

      local items = {
        Menu.item("Item 1"),
        Menu.separator("*"),
        Menu.item("Item Number Two"),
      }

      menu = Menu(popup_options, {
        lines = items,
        max_width = max_width,
      })

      menu:mount()

      eq(vim.api.nvim_win_get_width(menu.winid), max_width)

      h.assert_buf_lines(menu.bufnr, {
        "Item 1",
        " *    ",
        "Item …",
      })
    end)

    it("respects o.min_height", function()
      local min_height = 3

      local items = {
        Menu.item("A"),
        Menu.separator("*"),
        Menu.item("B"),
      }

      menu = Menu(popup_options, {
        lines = items,
        min_height = min_height,
      })

      menu:mount()

      eq(vim.api.nvim_win_get_height(menu.winid), min_height)
    end)

    it("respects o.max_height", function()
      local max_height = 2

      local items = {
        Menu.item("A"),
        Menu.separator("*"),
        Menu.item("B"),
      }

      menu = Menu(popup_options, {
        lines = items,
        max_height = max_height,
      })

      menu:mount()

      eq(vim.api.nvim_win_get_height(menu.winid), max_height)
    end)
  end)

  it("calls o.on_change item focus is changed", function()
    local on_change = spy.on(callbacks, "on_change")

    local lines = {
      Menu.item("Item 1", { id = 1 }),
      Menu.item("Item 2", { id = 2 }),
    }

    menu = Menu(popup_options, {
      lines = lines,
      on_change = on_change,
    })

    menu:mount()

    -- initial focus
    assert.spy(on_change).called_with(lines[1], menu)
    on_change:clear()

    feedkeys("j", "x")
    assert.spy(on_change).called_with(lines[2], menu)
    on_change:clear()

    feedkeys("j", "x")
    assert.spy(on_change).called_with(lines[1], menu)
    on_change:clear()

    feedkeys("k", "x")
    assert.spy(on_change).called_with(lines[2], menu)
    on_change:clear()
  end)

  it("calls o.on_submit when item is submitted", function()
    local on_submit = spy.on(callbacks, "on_submit")

    local lines = {
      Menu.item("Item 1", { id = 1 }),
      Menu.item("Item 2", { id = 2 }),
    }

    menu = Menu(popup_options, {
      lines = lines,
      on_submit = on_submit,
    })

    menu:mount()

    feedkeys("j", "x")
    feedkeys("<CR>", "x")

    assert.spy(on_submit).called_with(lines[2])
  end)

  it("calls o.on_close when menu is closed", function()
    local on_close = spy.on(callbacks, "on_close")

    local lines = {
      Menu.item("Item 1", { id = 1 }),
      Menu.item("Item 2", { id = 2 }),
    }

    menu = Menu(popup_options, {
      lines = lines,
      on_close = on_close,
    })

    menu:mount()

    feedkeys("<Esc>", "x")

    assert.spy(on_close).called_with()
  end)

  describe("item", function()
    it("is prepared using o.prepare_item if provided", function()
      local items = {
        Menu.item("A"),
        Menu.separator("*"),
        Menu.item("B"),
      }

      local function prepare_item(item)
        return "-" .. item.text .. "-"
      end

      menu = Menu(popup_options, {
        lines = items,
        prepare_item = prepare_item,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, vim.tbl_map(prepare_item, items))
    end)

    it("is prepared when o.prepare_item is not provided", function()
      local items = {
        Menu.item("A"),
        Menu.separator("*"),
        Menu.item("B"),
      }

      popup_options.border = "single"

      menu = Menu(popup_options, {
        lines = items,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        "A",
        "─*──",
        "B",
      })
    end)

    it("is skipped respecting o.should_skip_item if provided", function()
      local on_change = spy.on(callbacks, "on_change")

      local items = {
        Menu.item("-"),
        Menu.item("A", { id = 1 }),
        Menu.item("-"),
        Menu.item("B", { id = 2 }),
        Menu.item("-"),
      }

      menu = Menu(popup_options, {
        lines = items,
        on_change = on_change,
        should_skip_item = function(item)
          return not item.id
        end,
      })

      menu:mount()

      assert.spy(on_change).called_with(items[2], menu)
      on_change:clear()

      feedkeys("j", "x")
      assert.spy(on_change).called_with(items[4], menu)
      on_change:clear()

      feedkeys("j", "x")
      assert.spy(on_change).called_with(items[2], menu)
      on_change:clear()
    end)

    it("supports table with key .text", function()
      local text = "text"

      local items = {
        Menu.item({ text = text }),
      }

      menu = Menu(popup_options, {
        lines = items,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        text,
      })
    end)

    it("supports nui.text", function()
      local hl_group = "NuiMenuTest"
      local text = "text"
      local items = {
        Menu.item(Text(text, hl_group)),
      }

      menu = Menu(popup_options, {
        lines = items,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        text,
      })

      h.assert_highlight(menu.bufnr, menu.ns_id, 1, text, hl_group)
    end)

    it("supports nui.line", function()
      local hl_group = "NuiMenuTest"
      local text = "text"
      local items = {
        Menu.item(Line({ Text(text, hl_group) })),
      }

      menu = Menu(popup_options, {
        lines = items,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        text,
      })

      h.assert_highlight(menu.bufnr, menu.ns_id, 1, text, hl_group)
    end)

    it("content longer than max_width is truncated", function()
      local items = {
        Menu.item({ text = "Item 10 -" }),
        Menu.item(Text("Item 20 -")),
        Menu.item(Line({ Text("Item 30 -") })),
        Menu.item(Line({ Text("Item 40"), Text(" -") })),
        Menu.item(Line({ Text("Item 50 -"), Text(" -") })),
      }

      menu = Menu(popup_options, {
        max_width = 7,
        lines = items,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        "Item 1…",
        "Item 2…",
        "Item 3…",
        "Item 4…",
        "Item 5…",
      })
    end)
  end)

  describe("separator", function()
    it("text supports string", function()
      menu = Menu(popup_options, {
        lines = {
          Menu.item("A"),
          Menu.separator("Group"),
        },
        min_width = 10,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        "A",
        " Group    ",
      })
    end)

    it("content longer than max_width is truncated", function()
      menu = Menu(popup_options, {
        lines = {
          Menu.item("A"),
          Menu.separator("Long Long Group"),
        },
        max_width = 10,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        "A",
        " Long Lo… ",
      })
    end)

    it("text supports nui.text", function()
      local hl_group = "NuiMenuTest"
      local text = "Group"

      menu = Menu(popup_options, {
        lines = {
          Menu.item("A"),
          Menu.separator(Text(text, hl_group)),
        },
        min_width = 10,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        "A",
        " Group    ",
      })

      h.assert_highlight(menu.bufnr, menu.ns_id, 2, text, hl_group)
    end)

    it("text supports nui.line", function()
      local hl_group = "NuiMenuTest"
      local text = "Group"

      menu = Menu(popup_options, {
        lines = {
          Menu.item("A"),
          Menu.separator(Line({ Text(text, hl_group), Text(" nui.text") })),
        },
        min_width = 10,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        "A",
        " Group nui.t… ",
      })

      h.assert_highlight(menu.bufnr, menu.ns_id, 2, text, hl_group)
    end)

    it("o.char supports string", function()
      menu = Menu(popup_options, {
        lines = {
          Menu.item("A"),
          Menu.separator("Group", {
            char = "*",
            text_align = "right",
          }),
        },
        min_width = 10,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        "A",
        "****Group*",
      })
    end)

    it("o.char supports nui.text", function()
      local hl_group = "NuiMenuTest"

      menu = Menu(popup_options, {
        lines = {
          Menu.item("A"),
          Menu.separator("Group", {
            char = Text("*", hl_group),
            text_align = "center",
          }),
        },
        min_width = 10,
      })

      menu:mount()

      h.assert_buf_lines(menu.bufnr, {
        "A",
        "**Group***",
      })

      local linenr = 2

      local extmarks = h.get_line_extmarks(menu.bufnr, menu.ns_id, linenr)

      eq(#extmarks, 4)
      h.assert_extmark(extmarks[1], linenr, "*", hl_group)
      h.assert_extmark(extmarks[2], linenr, "*", hl_group)
      h.assert_extmark(extmarks[3], linenr, "**", hl_group)
      h.assert_extmark(extmarks[4], linenr, "*", hl_group)
    end)
  end)
end)

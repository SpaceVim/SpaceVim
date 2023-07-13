pcall(require, "luacov")

local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Split = require("nui.split")
local h = require("tests.helpers")
local spy = require("luassert.spy")

local eq, tbl_pick = h.eq, h.tbl_pick

local function create_popups(...)
  local popups = {}
  for _, popup_options in ipairs({ ... }) do
    table.insert(popups, Popup(popup_options))
  end
  return popups
end

local function create_splits(...)
  local splits = {}
  for _, split_options in ipairs({ ... }) do
    table.insert(splits, Split(split_options))
  end
  return splits
end

local function percent(number, percentage)
  return math.floor(number * percentage / 100)
end

local function get_assert_component(layout)
  local layout_winid = layout.winid
  assert(layout_winid, "missing layout.winid, forgot to mount it?")

  return function(component, expected)
    eq(type(component.bufnr), "number")
    eq(type(component.winid), "number")

    local win_config, border_win_config =
      vim.api.nvim_win_get_config(component.winid),
      component.border.winid and vim.api.nvim_win_get_config(component.border.winid)
    if border_win_config then
      eq(border_win_config.relative, "win")
      eq(border_win_config.win, layout_winid)

      eq(win_config.relative, "win")
      eq(win_config.win, component.border.winid)
    else
      eq(win_config.relative, "win")
      eq(win_config.win, layout_winid)
    end

    if border_win_config then
      local border_row, border_col = border_win_config.row[vim.val_idx], border_win_config.col[vim.val_idx]
      eq(border_row, expected.position.row)
      eq(border_col, expected.position.col)

      local row, col = win_config.row[vim.val_idx], win_config.col[vim.val_idx]
      eq(row, border_row + math.floor(component.border._.size_delta.width / 2 + 0.5))
      eq(col, border_col + math.floor(component.border._.size_delta.height / 2 + 0.5))
    else
      local row, col = win_config.row[vim.val_idx], win_config.col[vim.val_idx]
      eq(row, expected.position.row)
      eq(col, expected.position.col)
    end

    local expected_width, expected_height = expected.size.width, expected.size.height
    if component.border then
      expected_width = expected_width - component.border._.size_delta.width
      expected_height = expected_height - component.border._.size_delta.height
    end
    eq(vim.api.nvim_win_get_width(component.winid), expected_width)
    eq(vim.api.nvim_win_get_height(component.winid), expected_height)
  end
end

describe("nui.layout", function()
  local layout

  after_each(function()
    if layout then
      layout:unmount()
      layout = nil
    end
  end)

  describe("param box", function()
    it("throws if empty table", function()
      local ok, err = pcall(function()
        Layout({}, {})
      end)

      eq(ok, false)
      eq(type(string.match(err, "unexpected empty box")), "string")
    end)

    it("throws if empty box", function()
      local ok, err = pcall(function()
        Layout(
          {},
          Layout.Box({
            Layout.Box({
              Layout.Box({}, { size = "50%" }),
              Layout.Box({}, { size = "50%" }),
            }, { size = "100%" }),
          })
        )
      end)

      eq(ok, false)
      eq(type(string.match(err, "unexpected empty box")), "string")
    end)

    it("does not throw if non-empty", function()
      local p1 = unpack(create_popups({}))

      local ok, err = pcall(function()
        Layout(
          { position = "50%", size = "100%" },
          Layout.Box({
            Layout.Box({
              Layout.Box(p1, { size = "50%" }),
              Layout.Box({}, { size = "50%" }),
            }, { size = "100%" }),
          })
        )
      end)

      eq(ok, true)
      eq(err, nil)
    end)
  end)

  describe("box", function()
    it("requires child.size if child.grow is missing", function()
      local p1, p2 = unpack(create_popups({}, {}))

      local ok, result = pcall(function()
        Layout.Box({
          Layout.Box(p1, { size = "50%" }),
          Layout.Box(p2, {}),
        })
      end)

      eq(ok, false)
      eq(type(string.match(result, "missing child.size")), "string")
    end)

    it("does not require child.size if child.grow is present", function()
      local p1, p2 = unpack(create_popups({}, {}))

      local ok = pcall(function()
        Layout.Box({
          Layout.Box(p1, { size = "50%" }),
          Layout.Box(p2, { grow = 1 }),
        })
      end)

      eq(ok, true)
    end)

    describe("size (table)", function()
      it("missing height is set to 100% if dir=row", function()
        local p1, p2 = unpack(create_popups({}, {}))

        local box = Layout.Box({
          Layout.Box(p1, { size = { width = "40%" } }),
          Layout.Box(p2, { size = { width = "60%", height = "80%" } }),
        }, { dir = "row" })

        eq(box.box[1].size, {
          width = "40%",
          height = "100%",
        })
        eq(box.box[2].size, {
          width = "60%",
          height = "80%",
        })
      end)

      it("missing width is set to 100% if dir=col", function()
        local p1, p2 = unpack(create_popups({}, {}))

        local box = Layout.Box({
          Layout.Box(p1, { size = { height = "40%" } }),
          Layout.Box(p2, { size = { width = "60%", height = "80%" } }),
        }, { dir = "col" })

        eq(box.box[1].size, {
          width = "100%",
          height = "40%",
        })
        eq(box.box[2].size, {
          width = "60%",
          height = "80%",
        })
      end)
    end)

    describe("size (percentage string)", function()
      it("is set to width if dir=row", function()
        local p1, p2 = unpack(create_popups({}, {}))

        local box = Layout.Box({
          Layout.Box(p1, { size = "40%" }),
          Layout.Box(p2, { size = "60%" }),
        }, { dir = "row" })

        eq(box.box[1].size, {
          width = "40%",
          height = "100%",
        })
        eq(box.box[2].size, {
          width = "60%",
          height = "100%",
        })
      end)

      it("is set to height if dir=col", function()
        local p1, p2 = unpack(create_popups({}, {}))

        local box = Layout.Box({
          Layout.Box(p1, { size = "40%" }),
          Layout.Box(p2, { size = "60%" }),
        }, { dir = "col" })

        eq(box.box[1].size, {
          width = "100%",
          height = "40%",
        })
        eq(box.box[2].size, {
          width = "100%",
          height = "60%",
        })
      end)
    end)
  end)

  describe("[float]", function()
    describe("o.size", function()
      local box

      before_each(function()
        local p1 = unpack(create_popups({}))
        box = Layout.Box({ Layout.Box(p1, { size = "100%" }) })
      end)

      local function assert_size(size)
        local win_config = vim.api.nvim_win_get_config(layout.winid)

        eq(tbl_pick(win_config, { "width", "height" }), {
          width = math.floor(size.width),
          height = math.floor(size.height),
        })
      end

      it("supports number", function()
        local size = 20

        layout = Layout({
          position = "50%",
          size = size,
        }, box)

        layout:mount()

        assert_size({ width = size, height = size })
      end)

      it("supports percentage string", function()
        local percentage = 50

        layout = Layout({
          position = "50%",
          size = string.format("%s%%", percentage),
        }, box)

        local winid = vim.api.nvim_get_current_win()
        local win_width = vim.api.nvim_win_get_width(winid)
        local win_height = vim.api.nvim_win_get_height(winid)

        layout:mount()

        assert_size({
          width = win_width * percentage / 100,
          height = win_height * percentage / 100,
        })
      end)

      it("supports table", function()
        local width = 10
        local height_percentage = 50

        layout = Layout({
          position = "50%",
          size = {
            width = width,
            height = string.format("%s%%", height_percentage),
          },
        }, box)

        local winid = vim.api.nvim_get_current_win()
        local win_height = vim.api.nvim_win_get_height(winid)

        layout:mount()

        assert_size({
          width = width,
          height = win_height * height_percentage / 100,
        })
      end)
    end)

    describe("o.position", function()
      local box

      before_each(function()
        local p1 = unpack(create_popups({}))
        box = Layout.Box({ Layout.Box(p1, { size = "100%" }) })
      end)

      local function assert_position(position)
        local row, col = unpack(vim.api.nvim_win_get_position(layout.winid))

        eq(row, math.floor(position.row))
        eq(col, math.floor(position.col))
      end

      it("supports number", function()
        local position = 5

        layout = Layout({
          position = position,
          size = 10,
        }, box)

        layout:mount()

        assert_position({ row = position, col = position })
      end)

      it("supports percentage string", function()
        local size = 10
        local percentage = 50

        layout = Layout({
          position = string.format("%s%%", percentage),
          size = size,
        }, box)

        layout:mount()

        local winid = vim.api.nvim_get_current_win()
        local win_width = vim.api.nvim_win_get_width(winid)
        local win_height = vim.api.nvim_win_get_height(winid)

        assert_position({
          row = (win_height - size) * percentage / 100,
          col = (win_width - size) * percentage / 100,
        })
      end)

      it("supports table", function()
        local size = 10
        local row = 5
        local col_percentage = 50

        layout = Layout({
          position = {
            row = row,
            col = string.format("%s%%", col_percentage),
          },
          size = size,
        }, box)

        layout:mount()

        local winid = vim.api.nvim_get_current_win()
        local win_width = vim.api.nvim_win_get_width(winid)

        assert_position({
          row = row,
          col = (win_width - size) * col_percentage / 100,
        })
      end)
    end)

    describe("method :mount", function()
      it("mounts all components", function()
        local p1, p2 = unpack(create_popups({}, {}))

        local p1_mount = spy.on(p1, "mount")
        local p2_mount = spy.on(p2, "mount")

        layout = Layout(
          {
            position = "50%",
            size = {
              height = 20,
              width = 100,
            },
          },
          Layout.Box({
            Layout.Box(p1, { size = "50%" }),
            Layout.Box(p2, { size = "50%" }),
          })
        )

        layout:mount()

        eq(type(layout.bufnr), "number")
        eq(type(layout.winid), "number")

        assert.spy(p1_mount).was_called()
        assert.spy(p2_mount).was_called()
      end)

      it("is idempotent", function()
        local p1, p2 = unpack(create_popups({}, {}))

        local p1_mount = spy.on(p1, "mount")
        local p2_mount = spy.on(p2, "mount")

        layout = Layout(
          {
            position = "50%",
            size = 20,
          },
          Layout.Box({
            Layout.Box(p1, { size = "50%" }),
            Layout.Box(p2, { size = "50%" }),
          })
        )

        layout:mount()

        assert.spy(p1_mount).was_called(1)
        assert.spy(p2_mount).was_called(1)

        layout:mount()

        assert.spy(p1_mount).was_called(1)
        assert.spy(p2_mount).was_called(1)
      end)

      it("supports container component", function()
        local p1, p2 = unpack(create_popups({}, {}))

        local split = Split({
          relative = "editor",
          position = "bottom",
          size = 10,
        })

        local split_mount = spy.on(split, "mount")

        layout = Layout(
          split,
          Layout.Box({
            Layout.Box(p1, { size = "50%" }),
            Layout.Box(p2, { size = "50%" }),
          })
        )

        layout:mount()

        assert.spy(split_mount).was_called(1)

        local win_config = vim.api.nvim_win_get_config(layout.winid)
        eq(win_config.relative, "win")
        eq(win_config.row[vim.val_idx], 0)
        eq(win_config.col[vim.val_idx], 0)
        eq(win_config.width, vim.o.columns)
        eq(win_config.height, 10)

        split:unmount()
      end)

      it("throws if missing config 'size'", function()
        local p1 = unpack(create_popups({}, {}))

        local ok, result = pcall(function()
          layout = Layout({}, { Layout.Box(p1, { size = "100%" }) })
        end)

        eq(ok, false)
        eq(type(string.match(result, "missing layout config: size")), "string")
      end)

      it("throws if missing config 'position'", function()
        local p1 = unpack(create_popups({}, {}))

        local ok, result = pcall(function()
          layout = Layout({
            size = "50%",
          }, { Layout.Box(p1, { size = "100%" }) })
        end)

        eq(ok, false)
        eq(type(string.match(result, "missing layout config: position")), "string")
      end)
    end)

    h.describe_flipping_feature("lua_autocmd", "method :unmount", function()
      it("is called if any popup is unmounted", function()
        local p1, p2 = unpack(create_popups({}, {}, {}))

        layout = Layout(
          {
            position = "50%",
            size = 10,
          },
          Layout.Box({
            Layout.Box(p1, { size = "50%" }),
            Layout.Box(p2, { size = "50%" }),
          })
        )

        local layout_unmount = spy.on(layout, "unmount")

        layout:mount()

        p2:unmount()

        vim.wait(100, function()
          return not layout._.mounted
        end, 10)

        assert.spy(layout_unmount).was_called()
      end)

      it("is called if any popup is quitted", function()
        local p1, p2 = unpack(create_popups({}, {}))

        layout = Layout(
          {
            position = "50%",
            size = 10,
          },
          Layout.Box({
            Layout.Box(p1, { size = "50%" }),
            Layout.Box(p2, { size = "50%" }),
          })
        )

        local layout_unmount = spy.on(layout, "unmount")

        layout:mount()

        vim.api.nvim_buf_call(p2.bufnr, function()
          vim.cmd([[quit]])
        end)

        vim.wait(100, function()
          return not layout._.mounted
        end, 10)

        assert.spy(layout_unmount).was_called()
      end)
    end)

    h.describe_flipping_feature("lua_autocmd", "method :hide", function()
      it("does nothing if not mounted", function()
        local p1 = unpack(create_popups({}))

        local p1_hide = spy.on(p1, "hide")

        layout = Layout(
          {
            position = "50%",
            size = 10,
          },
          Layout.Box({
            Layout.Box(p1, { size = "100%" }),
          })
        )

        layout:hide()

        assert.spy(p1_hide).was_not_called()
      end)

      it("hides all components", function()
        local p1, p2, p3 = unpack(create_popups({}, {}, {}))

        local p1_hide = spy.on(p1, "hide")
        local p2_hide = spy.on(p2, "hide")
        local p3_hide = spy.on(p3, "hide")

        layout = Layout(
          {
            position = "50%",
            size = 10,
          },
          Layout.Box({
            Layout.Box(p1, { size = "50%" }),
            Layout.Box({
              Layout.Box(p2, { size = "50%" }),
              Layout.Box({
                Layout.Box(p3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        layout:mount()

        eq(type(layout.winid), "number")

        layout:hide()

        eq(type(layout.winid), "nil")

        assert.spy(p1_hide).was_called()
        assert.spy(p2_hide).was_called()
        assert.spy(p3_hide).was_called()
      end)

      it("is called if any popup is hidden", function()
        local p1, p2, p3 = unpack(create_popups({}, {}, {}))

        layout = Layout(
          {
            position = "50%",
            size = 10,
          },
          Layout.Box({
            Layout.Box(p1, { size = "50%" }),
            Layout.Box({
              Layout.Box(p2, { size = "50%" }),
              Layout.Box({
                Layout.Box(p3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        local layout_hide = spy.on(layout, "hide")

        layout:mount()

        p2:hide()

        assert.spy(layout_hide).was_called()
      end)
    end)

    describe("method :show", function()
      it("does nothing if not mounted", function()
        local p1 = unpack(create_popups({}))

        local p1_show = spy.on(p1, "show")

        layout = Layout(
          {
            position = "50%",
            size = 10,
          },
          Layout.Box({
            Layout.Box(p1, { size = "100%" }),
          })
        )

        layout:hide()
        layout:show()

        assert.spy(p1_show).was_not_called()
      end)

      it("shows all components", function()
        local p1, p2, p3 = unpack(create_popups({}, {}, {}))

        local p1_show = spy.on(p1, "show")
        local p2_show = spy.on(p2, "show")
        local p3_show = spy.on(p3, "show")

        layout = Layout(
          {
            position = "50%",
            size = 10,
          },
          Layout.Box({
            Layout.Box(p1, { size = "50%" }),
            Layout.Box({
              Layout.Box(p2, { size = "50%" }),
              Layout.Box({
                Layout.Box(p3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        layout:mount()

        layout:hide()
        layout:show()

        eq(type(layout.winid), "number")

        assert.spy(p1_show).was_called()
        assert.spy(p2_show).was_called()
        assert.spy(p3_show).was_called()
      end)
    end)

    describe("method :update", function()
      local winid, win_width, win_height
      local p1, p2, p3, p4
      local assert_component

      before_each(function()
        winid = vim.api.nvim_get_current_win()
        win_width = vim.api.nvim_win_get_width(winid)
        win_height = vim.api.nvim_win_get_height(winid)

        p1, p2, p3, p4 = unpack(create_popups({}, {}, {
          border = {
            style = "rounded",
          },
        }, {}))
      end)

      local function get_initial_layout(config)
        return Layout(
          config,
          Layout.Box({
            Layout.Box(p1, { size = "20%" }),
            Layout.Box({
              Layout.Box(p3, { size = "50%" }),
              Layout.Box(p4, { size = "50%" }),
            }, { dir = "col", size = "60%" }),
            Layout.Box(p2, { size = "20%" }),
          }, { dir = "row" })
        )
      end

      local function assert_layout_config(config)
        local relative, position, size = config.relative, config.position, config.size

        local win_config = vim.api.nvim_win_get_config(layout.winid)
        eq(win_config.relative, relative.type)
        eq(win_config.win, relative.winid)

        local row, col = unpack(vim.api.nvim_win_get_position(layout.winid))
        eq(row, position.row)
        eq(col, position.col)

        eq(vim.api.nvim_win_get_width(layout.winid), size.width)
        eq(vim.api.nvim_win_get_height(layout.winid), size.height)
      end

      local function assert_initial_layout_components()
        local size = {
          width = vim.api.nvim_win_get_width(layout.winid),
          height = vim.api.nvim_win_get_height(layout.winid),
        }

        assert_component(p1, {
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = percent(size.width, 20),
            height = size.height,
          },
        })

        assert_component(p3, {
          position = {
            row = 0,
            col = percent(size.width, 20),
          },
          size = {
            width = percent(size.width, 60),
            height = percent(size.height, 50),
          },
        })

        assert_component(p4, {
          position = {
            row = percent(size.height, 50),
            col = percent(size.width, 20),
          },
          size = {
            width = percent(size.width, 60),
            height = percent(size.height, 50),
          },
        })

        assert_component(p2, {
          position = {
            row = 0,
            col = percent(size.width, 20) + percent(size.width, 60),
          },
          size = {
            width = percent(size.width, 20),
            height = size.height,
          },
        })
      end

      it("processes layout correctly on mount", function()
        local layout_update_spy = spy.on(Layout, "update")

        layout = get_initial_layout({ position = 0, size = "100%" })

        layout:mount()

        layout_update_spy:revert()
        assert.spy(layout_update_spy).was_called(1)

        local expected_layout_config = {
          relative = {
            type = "win",
            winid = winid,
          },
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = win_width,
            height = win_height,
          },
        }

        assert_layout_config(expected_layout_config)

        assert_component = get_assert_component(layout)

        assert_initial_layout_components()
      end)

      it("can update layout win_config w/o rearranging boxes", function()
        layout = get_initial_layout({ position = 0, size = "100%" })

        layout:mount()

        layout:update({
          position = {
            row = 2,
            col = 4,
          },
          size = "80%",
        })

        local expected_layout_config = {
          relative = {
            type = "win",
            winid = winid,
          },
          position = {
            row = 2,
            col = 4,
          },
          size = {
            width = percent(win_width, 80),
            height = percent(win_height, 80),
          },
        }

        assert_layout_config(expected_layout_config)

        assert_component = get_assert_component(layout)

        assert_initial_layout_components()
      end)

      it("can rearrange boxes w/o changing layout win_config", function()
        layout = get_initial_layout({ position = 0, size = "100%" })

        layout:mount()

        layout:update(Layout.Box({
          Layout.Box(p2, { size = "30%" }),
          Layout.Box({
            Layout.Box(p4, { size = "40%" }),
            Layout.Box(p3, { size = "60%" }),
          }, { dir = "row", size = "30%" }),
          Layout.Box(p1, { size = "40%" }),
        }, { dir = "col" }))

        local expected_layout_config = {
          relative = {
            type = "win",
            winid = winid,
          },
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = win_width,
            height = win_height,
          },
        }

        assert_layout_config(expected_layout_config)

        assert_component = get_assert_component(layout)

        assert_component(p2, {
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = win_width,
            height = percent(win_height, 30),
          },
        })

        assert_component(p4, {
          position = {
            row = percent(win_height, 30),
            col = 0,
          },
          size = {
            width = percent(win_width, 40),
            height = percent(win_height, 30),
          },
        })

        assert_component(p3, {
          position = {
            row = percent(win_height, 30),
            col = percent(win_width, 40),
          },
          size = {
            width = percent(win_width, 60),
            height = percent(win_height, 30),
          },
        })

        assert_component(p1, {
          position = {
            row = percent(win_height, 30) + percent(win_height, 30),
            col = 0,
          },
          size = {
            width = win_width,
            height = percent(win_height, 40),
          },
        })
      end)

      it("refreshes layout if container size changes", function()
        local popup = Popup({
          position = 0,
          size = "100%",
        })

        popup:mount()

        layout = get_initial_layout({
          relative = {
            type = "win",
            winid = popup.winid,
          },
          position = 0,
          size = "80%",
        })

        layout:mount()

        local expected_layout_config = {
          relative = {
            type = "win",
            winid = popup.winid,
          },
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = percent(win_width, 80),
            height = percent(win_height, 80),
          },
        }

        assert_layout_config(expected_layout_config)

        assert_component = get_assert_component(layout)

        assert_initial_layout_components()

        popup:update_layout({
          size = "80%",
        })

        layout:update()

        expected_layout_config.size = {
          width = percent(percent(win_width, 80), 80),
          height = percent(percent(win_height, 80), 80),
        }

        assert_layout_config(expected_layout_config)

        assert_initial_layout_components()
      end)

      it("supports child with child.grow", function()
        layout = get_initial_layout({ position = 0, size = "100%" })

        layout:mount()

        layout:update(Layout.Box({
          Layout.Box(p1, { size = "20%" }),
          Layout.Box({
            Layout.Box({}, { size = 4 }),
            Layout.Box(p3, { grow = 1 }),
            Layout.Box({}, { size = 8 }),
            Layout.Box(p4, { grow = 1 }),
          }, { dir = "col", size = "60%" }),
          Layout.Box(p2, { grow = 1 }),
        }, { dir = "row" }))

        local expected_layout_config = {
          relative = {
            type = "win",
            winid = winid,
          },
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = win_width,
            height = win_height,
          },
        }

        assert_layout_config(expected_layout_config)

        assert_component = get_assert_component(layout)

        assert_component(p1, {
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = percent(win_width, 20),
            height = win_height,
          },
        })

        assert_component(p3, {
          position = {
            row = 4,
            col = percent(win_width, 20),
          },
          size = {
            width = percent(win_width, 60),
            height = percent(win_height - 4 - 8, 100 / 2),
          },
        })

        assert_component(p4, {
          position = {
            row = 4 + 8 + percent(win_height - 4 - 8, 100 / 2),
            col = percent(win_width, 20),
          },
          size = {
            width = percent(win_width, 60),
            height = percent(win_height - 4 - 8, 100 / 2),
          },
        })

        assert_component(p2, {
          position = {
            row = 0,
            col = percent(win_width, 20) + percent(win_width, 60),
          },
          size = {
            width = percent(win_width, 100 - 20 - 60),
            height = win_height,
          },
        })
      end)

      it("can change boxes", function()
        layout = Layout(
          { position = 0, size = "100%" },
          Layout.Box({
            Layout.Box(p1, { size = "40%" }),
            Layout.Box(p2, { size = "60%" }),
          }, { dir = "col" })
        )

        layout:mount()

        assert_component = get_assert_component(layout)

        assert_component(p1, {
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = win_width,
            height = percent(win_height, 40),
          },
        })

        assert_component(p2, {
          position = {
            row = percent(win_height, 40),
            col = 0,
          },
          size = {
            width = win_width,
            height = percent(win_height, 60),
          },
        })

        layout:update(Layout.Box({
          Layout.Box({
            Layout.Box(p1, { size = "40%" }),
            Layout.Box(p2, { size = "60%" }),
          }, { dir = "col", size = "60%" }),
          Layout.Box(p3, { size = "40%" }),
        }, { dir = "row" }))

        assert_component = get_assert_component(layout)

        assert_component(p1, {
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = percent(win_width, 60),
            height = percent(win_height, 40),
          },
        })

        assert_component(p2, {
          position = {
            row = percent(win_height, 40),
            col = 0,
          },
          size = {
            width = percent(win_width, 60),
            height = percent(win_height, 60),
          },
        })

        assert_component(p3, {
          position = {
            row = 0,
            col = percent(win_width, 60),
          },
          size = {
            width = percent(win_width, 40),
            height = win_height,
          },
        })

        layout:update(Layout.Box({
          Layout.Box({
            Layout.Box(p1, { size = "40%" }),
            Layout.Box(p2, { size = "60%" }),
          }, { dir = "col", size = "60%" }),
          Layout.Box(p4, { size = "40%" }),
        }, { dir = "row" }))

        assert_component(p4, {
          position = {
            row = 0,
            col = percent(win_width, 60),
          },
          size = {
            width = percent(win_width, 40),
            height = win_height,
          },
        })

        eq(p3.winid, nil)

        layout:update(Layout.Box({
          Layout.Box(p3, { size = "40%" }),
          Layout.Box(p4, { size = "60%" }),
        }, { dir = "col" }))

        eq(p1.winid, nil)
        eq(p2.winid, nil)

        assert_component(p3, {
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = win_width,
            height = percent(win_height, 40),
          },
        })

        assert_component(p4, {
          position = {
            row = percent(win_height, 40),
            col = 0,
          },
          size = {
            width = win_width,
            height = percent(win_height, 60),
          },
        })
      end)

      it("positions popup with complex border correctly", function()
        p1 = unpack(create_popups({
          border = {
            style = "single",
            text = {
              top = "text",
            },
            padding = { 1 },
          },
        }))

        layout = Layout(
          { position = 0, size = "100%" },
          Layout.Box({
            Layout.Box(p1, { size = "100%" }),
          }, { dir = "col" })
        )

        layout:mount()

        assert_component = get_assert_component(layout)

        assert_component(p1, {
          position = {
            row = 0,
            col = 0,
          },
          size = {
            width = win_width,
            height = percent(win_height, 100),
          },
        })
      end)
    end)
  end)

  describe("[split]", function()
    local function assert_size(winid, expected, tolerance)
      h.approx(vim.api.nvim_win_get_width(winid), expected.width, tolerance or 0)
      h.approx(vim.api.nvim_win_get_height(winid), expected.height, tolerance or 0)
    end

    describe("method :mount", function()
      it("mounts all components", function()
        local s1, s2, s3 = unpack(create_splits({}, {}, {}))

        local s1_mount = spy.on(s1, "mount")
        local s2_mount = spy.on(s2, "mount")
        local s3_mount = spy.on(s3, "mount")

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "50%" }),
            Layout.Box({
              Layout.Box(s2, { size = "50%" }),
              Layout.Box({
                Layout.Box(s3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        layout:mount()

        eq(type(layout.bufnr), "nil")
        eq(type(layout.winid), "nil")

        assert.spy(s1_mount).was_called()
        assert.spy(s2_mount).was_called()
        assert.spy(s3_mount).was_called()
      end)

      it("is idempotent", function()
        local s1, s2 = unpack(create_splits({}, {}))

        local s1_mount = spy.on(s1, "mount")
        local s2_mount = spy.on(s2, "mount")

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "50%" }),
            Layout.Box(s2, { size = "50%" }),
          })
        )

        layout:mount()

        assert.spy(s1_mount).was_called(1)
        assert.spy(s2_mount).was_called(1)

        layout:mount()

        assert.spy(s1_mount).was_called(1)
        assert.spy(s2_mount).was_called(1)
      end)

      it("mounts with correct layout", function()
        local winid = vim.api.nvim_get_current_win()

        local s1, s2, s3, s4, s5 = unpack(create_splits({}, {}, {}, {}, {}))

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "100%" }),
            Layout.Box({
              Layout.Box({
                Layout.Box(s2, { size = "100%" }),
              }, { dir = "col", size = "60%" }),
              Layout.Box({
                Layout.Box(s3, { size = "40%" }),
                Layout.Box(s4, { size = "60%" }),
              }, { dir = "row", size = "40%" }),
              Layout.Box({}, { size = "0%" }),
            }, { dir = "col", size = "40%" }),
            Layout.Box(s5, { size = "35%" }),
          })
        )

        layout:mount()

        eq(vim.fn.winlayout(), {
          "col",
          {
            { "leaf", winid },
            {
              "row",
              {
                { "leaf", s1.winid },
                {
                  "col",
                  {
                    { "leaf", s2.winid },
                    {
                      "row",
                      {
                        { "leaf", s3.winid },
                        { "leaf", s4.winid },
                      },
                    },
                  },
                },
                { "leaf", s5.winid },
              },
            },
          },
        })
      end)

      it("mounts with acceptable sizes", function()
        local winid = vim.api.nvim_get_current_win()
        local base_size = {
          width = vim.api.nvim_win_get_width(winid),
          height = vim.api.nvim_win_get_height(winid),
        }

        local s1, s2, s3, s4, s5 = unpack(create_splits({}, {}, {}, {}, {}))

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "25%" }),
            Layout.Box({
              Layout.Box({
                Layout.Box(s2, { size = "100%" }),
              }, { dir = "col", size = "60%" }),
              Layout.Box({
                Layout.Box(s3, { size = "40%" }),
                Layout.Box(s4, { size = "60%" }),
              }, { dir = "row", size = "40%" }),
              Layout.Box({}, { size = "0%" }),
            }, { dir = "col", size = "40%" }),
            Layout.Box(s5, { size = "35%" }),
          })
        )

        layout:mount()

        assert_size(s1.winid, {
          width = percent(base_size.width, 25),
          height = percent(20, 100),
        }, 2)

        assert_size(s2.winid, {
          width = percent(base_size.width, 40),
          height = percent(20, 60),
        }, 1)

        assert_size(s3.winid, {
          width = percent(percent(base_size.width, 40), 40),
          height = percent(20, 40),
        }, 1)

        assert_size(s4.winid, {
          width = percent(percent(base_size.width, 40), 60),
          height = percent(20, 40),
        }, 1)

        assert_size(s5.winid, {
          width = percent(base_size.width, 35),
          height = percent(20, 100),
        })
      end)
    end)

    describe("method :unmount", function()
      it("unmounts all components", function()
        local s1, s2, s3 = unpack(create_splits({}, {}, {}))

        local s1_unmount = spy.on(s1, "unmount")
        local s2_unmount = spy.on(s2, "unmount")
        local s3_unmount = spy.on(s3, "unmount")

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "50%" }),
            Layout.Box({
              Layout.Box(s2, { size = "50%" }),
              Layout.Box({
                Layout.Box(s3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        layout:mount()
        layout:unmount()

        assert.spy(s1_unmount).was_called()
        assert.spy(s2_unmount).was_called()
        assert.spy(s3_unmount).was_called()
      end)

      it("is called if any split is unmounted", function()
        local s1, s2, s3 = unpack(create_splits({}, {}, {}))

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "50%" }),
            Layout.Box({
              Layout.Box(s2, { size = "50%" }),
              Layout.Box({
                Layout.Box(s3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        local layout_unmount = spy.on(layout, "unmount")

        layout:mount()

        s2:unmount()

        vim.wait(100, function()
          return not layout._.mounted
        end, 10)

        assert.spy(layout_unmount).was_called()
      end)

      it("is called if any split is quitted", function()
        local s1, s2, s3 = unpack(create_splits({}, {}, {}))

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "50%" }),
            Layout.Box({
              Layout.Box(s2, { size = "50%" }),
              Layout.Box({
                Layout.Box(s3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        local layout_unmount = spy.on(layout, "unmount")

        layout:mount()

        vim.api.nvim_buf_call(s2.bufnr, function()
          vim.cmd([[quit]])
        end)

        vim.wait(100, function()
          return not layout._.mounted
        end, 10)

        assert.spy(layout_unmount).was_called()
      end)
    end)

    describe("method :hide", function()
      it("does nothing if not mounted", function()
        local s1 = unpack(create_splits({}))

        local s1_hide = spy.on(s1, "hide")

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "100%" }),
          })
        )

        layout:hide()

        assert.spy(s1_hide).was_not_called()
      end)

      it("hides all components", function()
        local s1, s2, s3 = unpack(create_splits({}, {}, {}))

        local s1_hide = spy.on(s1, "hide")
        local s2_hide = spy.on(s2, "hide")
        local s3_hide = spy.on(s3, "hide")

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "50%" }),
            Layout.Box({
              Layout.Box(s2, { size = "50%" }),
              Layout.Box({
                Layout.Box(s3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        layout:mount()

        layout:hide()

        assert.spy(s1_hide).was_called()
        assert.spy(s2_hide).was_called()
        assert.spy(s3_hide).was_called()
      end)

      it("is called if any split is hidden", function()
        local s1, s2, s3 = unpack(create_splits({}, {}, {}))

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "50%" }),
            Layout.Box({
              Layout.Box(s2, { size = "50%" }),
              Layout.Box({
                Layout.Box(s3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        local layout_hide = spy.on(layout, "hide")

        layout:mount()

        s2:hide()

        assert.spy(layout_hide).was_called()
      end)
    end)

    describe("method :show", function()
      it("does nothing if not mounted", function()
        local s1 = unpack(create_splits({}))

        local s1_show = spy.on(s1, "show")

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "100%" }),
          })
        )

        layout:hide()
        layout:show()

        assert.spy(s1_show).was_not_called()
      end)

      it("shows all components", function()
        local s1, s2, s3 = unpack(create_splits({}, {}, {}))

        local s1_show = spy.on(s1, "show")
        local s2_show = spy.on(s2, "show")
        local s3_show = spy.on(s3, "show")

        layout = Layout(
          {
            position = "bottom",
            size = 20,
          },
          Layout.Box({
            Layout.Box(s1, { size = "50%" }),
            Layout.Box({
              Layout.Box(s2, { size = "50%" }),
              Layout.Box({
                Layout.Box(s3, { size = "100%" }),
              }, { size = "50%" }),
            }, { size = "50%" }),
          })
        )

        layout:mount()

        layout:hide()
        layout:show()

        assert.spy(s1_show).was_called()
        assert.spy(s2_show).was_called()
        assert.spy(s3_show).was_called()
      end)
    end)

    describe("method :update", function()
      local winid, base_size
      local s1, s2, s3, s4

      before_each(function()
        winid = vim.api.nvim_get_current_win()
        base_size = {
          width = vim.api.nvim_win_get_width(winid),
          height = vim.api.nvim_win_get_height(winid),
        }

        s1, s2, s3, s4 = unpack(create_splits({}, {}, {}, {}))
      end)

      local function get_initial_layout(config)
        return Layout(
          config,
          Layout.Box({
            Layout.Box(s1, { size = "20%" }),
            Layout.Box({
              Layout.Box(s2, { size = "40%" }),
              Layout.Box(s3, { size = "60%" }),
            }, { dir = "col", size = "50%" }),
            Layout.Box(s4, { size = "30%" }),
          }, { dir = "row" })
        )
      end

      it("can update layout win_config w/o rearranging boxes", function()
        layout = get_initial_layout({
          position = "bottom",
          size = 10,
        })

        layout:mount()

        assert_size(s1.winid, {
          width = percent(base_size.width, 20),
          height = percent(10, 100),
        }, 2)

        assert_size(s2.winid, {
          width = percent(base_size.width, 50),
          height = percent(10, 40),
        }, 1)

        assert_size(s3.winid, {
          width = percent(base_size.width, 50),
          height = percent(10, 60),
        })

        assert_size(s4.winid, {
          width = percent(base_size.width, 30),
          height = percent(10, 100),
        })

        layout:update({ size = 20 })

        assert_size(s1.winid, {
          width = percent(base_size.width, 20),
          height = percent(20, 100),
        }, 2)

        assert_size(s2.winid, {
          width = percent(base_size.width, 50),
          height = percent(20, 40),
        }, 2)

        assert_size(s3.winid, {
          width = percent(base_size.width, 50),
          height = percent(20, 60),
        }, 2)

        assert_size(s4.winid, {
          width = percent(base_size.width, 30),
          height = percent(20, 100),
        })
      end)

      it("supports child with child.grow", function()
        layout = get_initial_layout({
          position = "bottom",
          size = 10,
        })

        layout:update(Layout.Box({
          Layout.Box(s1, { size = 20 }),
          Layout.Box({
            Layout.Box(s2, { grow = 1 }),
            Layout.Box(s3, { grow = 2 }),
          }, { dir = "col", grow = 2 }),
          Layout.Box(s4, { grow = 1 }),
        }, { dir = "row" }))

        layout:mount()

        assert_size(s1.winid, {
          width = 20,
          height = 10,
        }, 2)

        assert_size(s2.winid, {
          width = ((base_size.width - 20) / (2 + 1)) * 2,
          height = (10 / (1 + 2)) * 1,
        }, 1)

        assert_size(s3.winid, {
          width = ((base_size.width - 20) / (2 + 1)) * 2,
          height = (10 / (1 + 2)) * 2,
        }, 1)

        assert_size(s4.winid, {
          width = ((base_size.width - 20) / (2 + 1)) * 1,
          height = 10,
        })
      end)

      it("can change boxes", function()
        layout = Layout(
          { position = "bottom", size = 10 },
          Layout.Box({
            Layout.Box(s1, { size = "40%" }),
            Layout.Box(s2, { size = "60%" }),
          }, { dir = "row" })
        )

        layout:mount()

        eq(vim.fn.winlayout(), {
          "col",
          {
            { "leaf", winid },
            {
              "row",
              {
                { "leaf", s1.winid },
                { "leaf", s2.winid },
              },
            },
          },
        })

        layout:update(Layout.Box({
          Layout.Box({
            Layout.Box(s1, { size = "40%" }),
            Layout.Box(s2, { size = "60%" }),
          }, { dir = "col", size = "60%" }),
          Layout.Box(s3, { size = "40%" }),
        }, { dir = "row" }))

        eq(vim.fn.winlayout(), {
          "col",
          {
            { "leaf", winid },
            {
              "row",
              {
                {
                  "col",
                  {
                    { "leaf", s1.winid },
                    { "leaf", s2.winid },
                  },
                },
                { "leaf", s3.winid },
              },
            },
          },
        })

        layout:update(Layout.Box({
          Layout.Box({
            Layout.Box(s1, { size = "40%" }),
            Layout.Box(s2, { size = "60%" }),
          }, { dir = "col", size = "60%" }),
          Layout.Box(s4, { size = "40%" }),
        }, { dir = "row" }))

        eq(vim.fn.winlayout(), {
          "col",
          {
            { "leaf", winid },
            {
              "row",
              {
                {
                  "col",
                  {
                    { "leaf", s1.winid },
                    { "leaf", s2.winid },
                  },
                },
                { "leaf", s4.winid },
              },
            },
          },
        })

        eq(s3.winid, nil)
      end)
    end)
  end)
end)

pcall(require, "luacov")

local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local h = require("tests.helpers")
local spy = require("luassert.spy")

local eq, feedkeys = h.eq, h.feedkeys

local function percent(number, percentage)
  return math.floor(number * percentage / 100)
end

describe("nui.popup", function()
  local popup

  after_each(function()
    if popup then
      popup:unmount()
      popup = nil
    end
  end)

  it("supports o.bufnr (unmanaed buffer)", function()
    local bufnr = vim.api.nvim_create_buf(false, true)

    local lines = {
      "a",
      "b",
      "c",
    }

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    popup = Popup({
      bufnr = bufnr,
      position = "50%",
      size = {
        height = "60%",
        width = "80%",
      },
    })

    h.assert_buf_lines(bufnr, lines)
    eq(popup.bufnr, bufnr)
    popup:mount()
    h.assert_buf_lines(bufnr, lines)
    popup:unmount()
    eq(popup.bufnr, bufnr)
    h.assert_buf_lines(bufnr, lines)
  end)

  it("accepts number as o.ns_id", function()
    local ns = "NuiPopupTest"
    local ns_id = vim.api.nvim_create_namespace(ns)

    popup = Popup({
      ns_id = ns_id,
      position = "50%",
      size = {
        height = "60%",
        width = "80%",
      },
    })

    eq(popup.ns_id, ns_id)
  end)

  it("accepts string as o.ns_id", function()
    local ns = "NuiPopupTest"

    popup = Popup({
      ns_id = ns,
      position = "50%",
      size = {
        height = "60%",
        width = "80%",
      },
    })

    eq(popup.ns_id, vim.api.nvim_create_namespace(ns))
  end)

  it("uses fallback ns_id if o.ns_id=nil", function()
    popup = Popup({
      position = "50%",
      size = {
        height = "60%",
        width = "80%",
      },
    })

    eq(type(popup.ns_id), "number")
    eq(popup.ns_id > 0, true)
  end)

  h.describe_flipping_feature("lua_keymap", "method :map", function()
    it("works before :mount", function()
      local callback = spy.new(function() end)

      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:map("n", "l", function()
        callback()
      end)

      popup:mount()

      feedkeys("l", "x")

      assert.spy(callback).called()
    end)

    it("works after :mount", function()
      local callback = spy.new(function() end)

      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:map("n", "l", function()
        callback()
      end)

      feedkeys("l", "x")

      assert.spy(callback).called()
    end)

    it("supports lhs table", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:map("n", { "k", "l" }, "o42<esc>")

      feedkeys("k", "x")
      feedkeys("l", "x")

      h.assert_buf_lines(popup.bufnr, {
        "",
        "42",
        "42",
      })
    end)

    it("supports rhs function", function()
      local callback = spy.new(function() end)

      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:map("n", "l", function()
        callback()
      end)

      feedkeys("l", "x")

      assert.spy(callback).called()
    end)

    it("supports rhs string", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:map("n", "l", "o42<esc>")

      feedkeys("l", "x")

      h.assert_buf_lines(popup.bufnr, {
        "",
        "42",
      })
    end)

    it("supports o.remap=true", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:map("n", "k", "o42<Esc>")
      popup:map("n", "l", "k", { remap = true })

      feedkeys("k", "x")
      feedkeys("l", "x")

      h.assert_buf_lines(popup.bufnr, {
        "",
        "42",
        "42",
      })
    end)

    it("supports o.remap=false", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:map("n", "k", "o42<Esc>")
      popup:map("n", "l", "k", { remap = false })

      feedkeys("k", "x")
      feedkeys("l", "x")

      h.assert_buf_lines(popup.bufnr, {
        "",
        "42",
      })
    end)

    it("throws if .bufnr is nil", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup.bufnr = nil

      local ok, result = pcall(function()
        popup:map("n", "l", function() end)
      end)

      eq(ok, false)
      eq(type(string.match(result, "buffer not found")), "string")
    end)
  end)

  h.describe_flipping_feature("lua_keymap", "method :unmap", function()
    it("works before :mount", function()
      local callback = spy.new(function() end)

      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:map("n", "l", function()
        callback()
      end)

      popup:unmap("n", "l")

      popup:mount()

      feedkeys("l", "x")

      assert.spy(callback).not_called()
    end)

    it("works after :mount", function()
      local callback = spy.new(function() end)

      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:map("n", "l", function()
        callback()
      end)

      popup:unmap("n", "l")

      feedkeys("l", "x")

      assert.spy(callback).not_called()
    end)

    it("supports lhs string", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:map("n", "l", "o42<esc>")

      popup:unmap("n", "l")

      feedkeys("l", "x")

      h.assert_buf_lines(popup.bufnr, {
        "",
      })
    end)

    it("supports lhs table", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:map("n", "k", "o42<esc>")
      popup:map("n", "l", "o42<esc>")

      popup:unmap("n", { "k", "l" })

      feedkeys("k", "x")
      feedkeys("l", "x")

      h.assert_buf_lines(popup.bufnr, {
        "",
      })
    end)

    it("throws if .bufnr is nil", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup.bufnr = nil

      local ok, result = pcall(function()
        popup:unmap("n", "l")
      end)

      eq(ok, false)
      eq(type(string.match(result, "buffer not found")), "string")
    end)
  end)

  h.describe_flipping_feature("lua_autocmd", "method :on", function()
    it("works before :mount", function()
      local callback = spy.new(function() end)

      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:on(event.InsertEnter, function()
        callback()
      end)

      popup:mount()

      feedkeys("i", "x")
      feedkeys("<esc>", "x")

      assert.spy(callback).called()
    end)

    it("works after :mount", function()
      local callback = spy.new(function() end)

      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:on(event.InsertEnter, function()
        callback()
      end)

      feedkeys("i", "x")
      feedkeys("<esc>", "x")

      assert.spy(callback).called()
    end)

    it("throws if .bufnr is nil", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup.bufnr = nil

      local ok, result = pcall(function()
        popup:on(event.InsertEnter, function() end)
      end)

      eq(ok, false)
      eq(type(string.match(result, "buffer not found")), "string")
    end)
  end)

  h.describe_flipping_feature("lua_autocmd", "method :off", function()
    it("works before :mount", function()
      local callback = spy.new(function() end)

      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:on(event.InsertEnter, function()
        callback()
      end)

      popup:off(event.InsertEnter)

      popup:mount()

      feedkeys("i", "x")
      feedkeys("<esc>", "x")

      assert.spy(callback).not_called()
    end)

    it("works after :mount", function()
      local callback = spy.new(function() end)

      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup:mount()

      popup:on(event.InsertEnter, function()
        callback()
      end)

      popup:off(event.InsertEnter)

      feedkeys("i", "x")
      feedkeys("<esc>", "x")

      assert.spy(callback).not_called()
    end)

    it("throws if .bufnr is nil", function()
      popup = Popup({
        enter = true,
        position = "50%",
        size = {
          height = "60%",
          width = "80%",
        },
      })

      popup.bufnr = nil

      local ok, result = pcall(function()
        popup:off()
      end)

      eq(ok, false)
      eq(type(string.match(result, "buffer not found")), "string")
    end)
  end)

  describe("method :update_layout", function()
    local function assert_size(size, border_size)
      if border_size and type(border_size) ~= "table" then
        border_size = {
          width = size.width + 2,
          height = size.height + 2,
        }
      end

      local win_config = vim.api.nvim_win_get_config(popup.winid)
      eq(win_config.width, size.width)
      eq(win_config.height, size.height)

      if popup.border.winid then
        local border_win_config = vim.api.nvim_win_get_config(popup.border.winid)
        eq(border_win_config.width, border_size.width)
        eq(border_win_config.height, border_size.height)
      end
    end

    local function assert_position(position, container_winid)
      container_winid = container_winid or vim.api.nvim_get_current_win()

      local win_config = vim.api.nvim_win_get_config(popup.winid)
      eq(win_config.win, popup.border.winid or container_winid)

      local row, col = win_config.row[vim.val_idx], win_config.col[vim.val_idx]

      if popup.border.winid then
        eq(row, 1)
        eq(col, 1)

        local border_win_config = vim.api.nvim_win_get_config(popup.border.winid)
        local border_row, border_col = border_win_config.row[vim.val_idx], border_win_config.col[vim.val_idx]
        local border_width, border_height = border_win_config.width, border_win_config.height

        local delta_width = border_width - win_config.width
        local delta_height = border_height - win_config.height

        eq(border_row + math.floor(delta_height / 2 + 0.5), position.row)
        eq(border_col + math.floor(delta_width / 2 + 0.5), position.col)
      else
        eq(row, position.row)
        eq(col, position.col)
      end
    end

    it("can change size (w/ simple border)", function()
      local size = {
        width = 2,
        height = 1,
      }

      popup = Popup({
        position = "50%",
        size = size,
      })

      popup:mount()

      eq(type(popup.border.winid), "nil")

      assert_size(size)

      local new_size = {
        width = size.width + 2,
        height = size.height + 2,
      }

      popup:update_layout({ size = new_size })

      assert_size(new_size)
    end)

    it("can change size (w/ complex border)", function()
      local hl_group = "NuiPopupTest"
      local style = h.popup.create_border_style_map_with_tuple(hl_group)

      local size = {
        width = 2,
        height = 1,
      }

      popup = Popup({
        ns_id = vim.api.nvim_create_namespace("NuiTest"),
        border = {
          style = style,
          padding = { 0 },
        },
        position = "50%",
        size = size,
      })

      popup:mount()

      eq(type(popup.border.winid), "number")

      assert_size(size, true)
      h.popup.assert_border_lines({
        size = size,
        border = { style = style },
      }, popup.border.bufnr)
      h.popup.assert_border_highlight({
        size = size,
        ns_id = popup.ns_id,
      }, popup.border.bufnr, hl_group)

      local new_size = {
        width = size.width + 2,
        height = size.height + 2,
      }

      popup:update_layout({ size = new_size })

      assert_size(new_size, true)
      h.popup.assert_border_lines({
        size = new_size,
        border = { style = style },
      }, popup.border.bufnr)
      h.popup.assert_border_highlight({
        size = new_size,
        ns_id = popup.ns_id,
      }, popup.border.bufnr, hl_group)
    end)

    it("can change position (w/ simple border)", function()
      local position = {
        row = 0,
        col = 0,
      }

      popup = Popup({
        position = position,
        size = {
          width = 4,
          height = 2,
        },
      })

      popup:mount()

      eq(type(popup.border.winid), "nil")

      assert_position(position)

      local new_position = {
        row = position.row + 2,
        col = position.col + 2,
      }

      popup:update_layout({ position = new_position })

      assert_position(new_position)
    end)

    it("can change position (w/ complex border)", function()
      local hl_group = "NuiPopupTest"
      local style = h.popup.create_border_style_map_with_tuple(hl_group)

      local position = {
        row = 0,
        col = 0,
      }

      popup = Popup({
        ns_id = vim.api.nvim_create_namespace("NuiTest"),
        border = {
          style = style,
          padding = { 0 },
        },
        position = position,
        size = {
          width = 4,
          height = 2,
        },
      })

      popup:mount()

      eq(type(popup.border.winid), "number")

      assert_position(position)

      local new_position = {
        row = position.row + 2,
        col = position.col + 2,
      }

      popup:update_layout({ position = new_position })

      assert_position(new_position)
    end)

    it("refreshes layout if container size changes", function()
      local container_size = {
        width = 20,
        height = 10,
      }

      local container_popup = Popup({
        position = 0,
        size = container_size,
      })

      container_popup:mount()

      popup = Popup({
        relative = {
          type = "win",
          winid = container_popup.winid,
        },
        position = "20%",
        size = "50%",
      })

      popup:mount()

      assert_size({
        width = percent(container_size.width, 50),
        height = percent(container_size.height, 50),
      })

      assert_position({
        row = percent(container_size.height - percent(container_size.height, 50), 20),
        col = percent(container_size.width - percent(container_size.width, 50), 20),
      }, container_popup.winid)

      container_size = {
        width = 16,
        height = 8,
      }

      container_popup:update_layout({
        size = container_size,
      })

      popup:update_layout()

      assert_size({
        width = percent(container_size.width, 50),
        height = percent(container_size.height, 50),
      })

      assert_position({
        row = percent(container_size.height - percent(container_size.height, 50), 20),
        col = percent(container_size.width - percent(container_size.width, 50), 20),
      }, container_popup.winid)
    end)

    it("throws if missing config 'relative'", function()
      popup = Popup({})

      local ok, result = pcall(function()
        popup:update_layout({})
      end)

      eq(ok, false)
      eq(type(string.match(result, "missing layout config: relative")), "string")
    end)

    it("throws if missing config 'size'", function()
      popup = Popup({})

      local ok, result = pcall(function()
        popup:update_layout({
          relative = "win",
        })
      end)

      eq(ok, false)
      eq(type(string.match(result, "missing layout config: size")), "string")
    end)

    it("throws if missing config 'position'", function()
      popup = Popup({})

      local ok, result = pcall(function()
        popup:update_layout({
          relative = "win",
          size = "50%",
        })
      end)

      eq(ok, false)
      eq(type(string.match(result, "missing layout config: position")), "string")
    end)
  end)

  describe("method :mount", function()
    it("throws if layout is not ready", function()
      popup = Popup({})

      local ok, result = pcall(function()
        popup:mount()
      end)

      eq(ok, false)
      eq(type(string.match(result, "layout is not ready")), "string")
    end)

    it("is idempotent", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      local border_mount = spy.on(popup.border, "mount")

      popup:mount()

      local bufnr, winid = popup.bufnr, popup.winid

      eq(type(bufnr), "number")
      eq(type(winid), "number")
      assert.spy(border_mount).was_called(1)

      popup:mount()

      eq(bufnr, popup.bufnr)
      eq(winid, popup.winid)
      assert.spy(border_mount).was_called(1)
    end)
  end)

  h.describe_flipping_feature("lua_autocmd", "method :unmount", function()
    it("is called when quitted", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      local popup_unmount = spy.on(popup, "unmount")

      popup:mount()

      vim.api.nvim_buf_call(popup.bufnr, function()
        vim.cmd([[quit]])
      end)

      vim.wait(100, function()
        return not popup._.mounted
      end, 10)

      assert.spy(popup_unmount).was_called()
    end)
  end)

  h.describe_flipping_feature("lua_autocmd", "method :hide", function()
    it("works", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      popup:mount()

      vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, {
        "42",
      })

      eq(type(popup.bufnr), "number")
      eq(type(popup.winid), "number")

      popup:hide()

      eq(type(popup.bufnr), "number")
      eq(type(popup.winid), "nil")

      h.assert_buf_lines(popup.bufnr, {
        "42",
      })
    end)

    it("is idempotent", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      popup:mount()

      local prev_winids = vim.api.nvim_list_wins()

      popup:hide()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids, #curr_winids + 1)

      popup:hide()

      eq(#curr_winids, #vim.api.nvim_list_wins())
    end)

    it("does nothing if not mounted", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      local prev_winids = vim.api.nvim_list_wins()

      popup:hide()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids, #curr_winids)
    end)

    it("is called when window is closed", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      local popup_hide = spy.on(popup, "hide")

      popup:mount()

      vim.api.nvim_buf_call(popup.bufnr, function()
        vim.cmd([[:bdelete]])
      end)

      assert.spy(popup_hide).was_called()
    end)

    it("is not called when other popup using same buffer is hidden", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      local another_popup = Popup({
        bufnr = popup.bufnr,
        position = 11,
        size = 5,
      })

      local popup_hide = spy.on(popup, "hide")

      popup:mount()

      another_popup:mount()
      another_popup:hide()

      assert.spy(popup_hide).was_not_called()

      another_popup:unmount()
    end)
  end)

  h.describe_flipping_feature("lua_autocmd", "method :show", function()
    it("works", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      popup:mount()

      vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, {
        "42",
      })

      local bufnr, winid = popup.bufnr, popup.winid
      eq(type(bufnr), "number")
      eq(type(winid), "number")

      popup:hide()
      popup:show()

      eq(bufnr, popup.bufnr)
      eq(type(popup.winid), "number")
      eq(winid ~= popup.winid, true)

      h.assert_buf_lines(popup.bufnr, {
        "42",
      })
    end)

    it("is idempotent", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      popup:mount()

      popup:hide()

      local prev_winids = vim.api.nvim_list_wins()

      popup:show()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids + 1, #curr_winids)

      popup:show()

      eq(#curr_winids, #vim.api.nvim_list_wins())
    end)

    it("does nothing if not mounted", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      local prev_winids = vim.api.nvim_list_wins()

      popup:show()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids, #curr_winids)
    end)

    it("does nothing if not hidden", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      popup:mount()

      local prev_winids = vim.api.nvim_list_wins()

      popup:show()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids, #curr_winids)
    end)

    it("can show popups using the same buffer", function()
      popup = Popup({
        position = 0,
        size = 10,
      })

      vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, {
        "42",
      })

      local another_popup = Popup({
        bufnr = popup.bufnr,
        position = 11,
        size = 5,
      })

      popup:mount()
      another_popup:mount()

      local bufnr, winid = popup.bufnr, popup.winid
      eq(type(bufnr), "number")
      eq(type(winid), "number")

      local another_bufnr, another_winid = another_popup.bufnr, another_popup.winid
      eq(type(another_bufnr), "number")
      eq(type(another_winid), "number")

      eq(bufnr, another_bufnr)

      popup:hide()
      another_popup:hide()

      popup:show()
      another_popup:show()

      eq(bufnr, popup.bufnr)
      eq(type(popup.winid), "number")
      eq(winid ~= popup.winid, true)

      eq(another_bufnr, another_popup.bufnr)
      eq(type(another_popup.winid), "number")
      eq(another_winid ~= another_popup.winid, true)

      h.assert_buf_lines(bufnr, {
        "42",
      })
    end)
  end)
end)

pcall(require, "luacov")

local Split = require("nui.split")
local event = require("nui.utils.autocmd").event
local h = require("tests.helpers")
local spy = require("luassert.spy")

local eq, feedkeys = h.eq, h.feedkeys

local function percent(number, percentage)
  return math.floor(number * percentage / 100)
end

describe("nui.split", function()
  local split

  before_each(function()
    vim.o.winwidth = 10
  end)

  after_each(function()
    split:unmount()
  end)

  describe("o.enter", function()
    it("if true, sets the split as current window", function()
      split = Split({
        enter = true,
        size = 10,
        position = "bottom",
      })

      local winid = vim.api.nvim_get_current_win()

      split:mount()

      h.eq(winid ~= split.winid, true)
      h.eq(split.winid, vim.api.nvim_get_current_win())
    end)

    it("if false, does not set the split as current window", function()
      split = Split({
        enter = false,
        size = 10,
        position = "bottom",
      })

      local winid = vim.api.nvim_get_current_win()

      split:mount()

      h.eq(winid ~= split.winid, true)
      h.eq(winid, vim.api.nvim_get_current_win())
    end)

    it("is true by default", function()
      split = Split({
        size = 10,
        position = "bottom",
      })

      local winid = vim.api.nvim_get_current_win()

      split:mount()

      h.eq(winid ~= split.winid, true)
      h.eq(split.winid, vim.api.nvim_get_current_win())
    end)
  end)

  describe("o.size", function()
    for position, dimension in pairs({ top = "height", right = "width", bottom = "height", left = "width" }) do
      it(string.format("is set as %s if o.position=%s", dimension, position), function()
        local size = 20

        split = Split({
          size = size,
          position = position,
        })

        split:mount()

        local nvim_method = string.format("nvim_win_get_%s", dimension)

        eq(vim.api[nvim_method](split.winid), size)
      end)
    end

    it("supports table (.width)", function()
      local size = 10

      split = Split({
        size = { width = size },
        position = "left",
      })

      split:mount()

      eq(vim.api.nvim_win_get_width(split.winid), size)
    end)

    it("supports table (.height)", function()
      local size = 10

      split = Split({
        size = { height = size },
        position = "top",
      })

      split:mount()

      eq(vim.api.nvim_win_get_height(split.winid), size)
    end)

    it("is optional", function()
      split = Split({
        position = "bottom",
      })

      split:mount()

      eq(type(vim.api.nvim_win_get_height(split.winid)), "number")
    end)

    it("works with relative='editor'", function()
      vim.api.nvim_set_option("showtabline", 2)
      vim.api.nvim_set_option("cmdheight", 2)

      split = Split({
        size = "50%",
        position = "bottom",
        relative = "editor",
      })

      split:mount()

      eq(vim.api.nvim_win_get_height(split.winid), math.floor((vim.o.lines - 4) / 2))

      vim.api.nvim_set_option("cmdheight", 1)
      vim.api.nvim_set_option("showtabline", 1)
    end)
  end)

  describe("o.relative", function()
    it("supports 'editor'", function()
      local left_half_split = Split({
        size = "50%",
        position = "left",
      })

      left_half_split:mount()

      split = Split({
        size = 20,
        position = "bottom",
        relative = "editor",
      })

      split:mount()

      eq(vim.api.nvim_win_get_width(split.winid), vim.o.columns)

      left_half_split:unmount()
    end)

    it("supports 'win'", function()
      local left_half_split = Split({
        size = "50%",
        position = "left",
      })

      left_half_split:mount()

      split = Split({
        size = 20,
        position = "bottom",
        relative = "win",
      })

      split:mount()

      eq(vim.api.nvim_win_get_width(split.winid), vim.o.columns / 2)

      left_half_split:unmount()
    end)

    it("supports specific window", function()
      local winid = vim.api.nvim_get_current_win()

      local left_half_split = Split({
        enter = false,
        size = "30%",
        position = "left",
      })

      left_half_split:mount()

      eq(winid, vim.api.nvim_get_current_win())

      eq(vim.api.nvim_win_get_width(left_half_split.winid), vim.o.columns * 30 / 100)

      split = Split({
        enter = false,
        size = 10,
        position = "bottom",
        relative = {
          type = "win",
          winid = left_half_split.winid,
        },
      })

      split:mount()

      eq(winid, vim.api.nvim_get_current_win())

      eq(vim.api.nvim_win_get_width(split.winid), vim.o.columns * 30 / 100)

      left_half_split:unmount()
    end)
  end)

  describe("method :mount", function()
    it("opens win if not mounted", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      local prev_winids = vim.api.nvim_list_wins()

      split:mount()

      local new_winids = vim.tbl_filter(function(winid)
        return not vim.tbl_contains(prev_winids, winid)
      end, vim.api.nvim_list_wins())

      eq(#new_winids, 1)
    end)

    it("does nothing if already mounted", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      split:mount()

      local prev_winids = vim.api.nvim_list_wins()

      split:mount()

      local new_winids = vim.tbl_filter(function(winid)
        return not vim.tbl_contains(prev_winids, winid)
      end, vim.api.nvim_list_wins())

      eq(#new_winids, 0)
    end)

    it("sets buffer after creating window", function()
      local ok, winid = false, nil

      split = Split({
        size = 20,
        position = "bottom",
      })

      split:on(event.BufWinEnter, function()
        ok, winid = true, split.winid
      end)

      split:mount()

      eq(type(split.winid), "number")

      eq(ok, true)
      eq(winid, split.winid)
    end)
  end)

  h.describe_flipping_feature("lua_autocmd", "method :unmount", function()
    it("closes win if mounted", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      split:mount()

      local split_winid = split.winid

      local prev_winids = vim.api.nvim_list_wins()

      split:unmount()

      local curr_winids = vim.api.nvim_list_wins()
      local closed_winids = vim.tbl_filter(function(winid)
        return not vim.tbl_contains(curr_winids, winid)
      end, prev_winids)

      eq(#closed_winids, 1)
      eq(closed_winids[1], split_winid)
    end)

    it("does nothing if already unmounted", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      local prev_winids = vim.api.nvim_list_wins()

      split:unmount()

      local curr_winids = vim.api.nvim_list_wins()
      local closed_winids = vim.tbl_filter(function(winid)
        return not vim.tbl_contains(curr_winids, winid)
      end, prev_winids)

      eq(#closed_winids, 0)
    end)

    it("is called when quitted", function()
      split = Split({
        size = 10,
        position = "bottom",
      })

      local split_unmount = spy.on(split, "unmount")

      split:mount()

      vim.api.nvim_buf_call(split.bufnr, function()
        vim.cmd([[quit]])
      end)

      vim.wait(100, function()
        return not split._.mounted
      end, 10)

      assert.spy(split_unmount).was_called()
    end)
  end)

  h.describe_flipping_feature("lua_autocmd", "method :hide", function()
    it("works", function()
      local winid = vim.api.nvim_get_current_win()

      local win_height = vim.api.nvim_win_get_height(winid)

      split = Split({
        size = 20,
        position = "bottom",
      })

      split:mount()

      vim.api.nvim_buf_set_lines(split.bufnr, 0, -1, false, {
        "42",
      })

      eq(vim.api.nvim_win_get_height(winid) < win_height, true)

      split:hide()

      h.assert_buf_lines(split.bufnr, {
        "42",
      })

      eq(vim.api.nvim_win_get_height(winid) == win_height, true)
    end)

    it("is idempotent", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      split:mount()

      local prev_winids = vim.api.nvim_list_wins()

      split:hide()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids, #curr_winids + 1)

      split:hide()

      eq(#curr_winids, #vim.api.nvim_list_wins())
    end)

    it("does nothing if not mounted", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      local prev_winids = vim.api.nvim_list_wins()

      split:hide()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids, #curr_winids)
    end)

    it("is called when window is closed", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      local split_hide = spy.on(split, "hide")

      split:mount()

      vim.api.nvim_buf_call(split.bufnr, function()
        vim.cmd([[:bdelete]])
      end)

      assert.spy(split_hide).was_called()
    end)
  end)

  describe("method :show", function()
    it("works", function()
      local winid = vim.api.nvim_get_current_win()

      split = Split({
        size = 20,
        position = "bottom",
      })

      split:mount()

      vim.api.nvim_buf_set_lines(split.bufnr, 0, -1, false, {
        "42",
      })

      local win_height = vim.api.nvim_win_get_height(winid)

      split:hide()
      split:show()

      h.assert_buf_lines(split.bufnr, {
        "42",
      })

      eq(vim.api.nvim_win_get_height(winid) == win_height, true)
    end)

    it("is idempotent", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      split:mount()

      split:hide()

      local prev_winids = vim.api.nvim_list_wins()

      split:show()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids + 1, #curr_winids)

      split:show()

      eq(#curr_winids, #vim.api.nvim_list_wins())
    end)

    it("does nothing if not mounted", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      local prev_winids = vim.api.nvim_list_wins()

      split:show()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids, #curr_winids)
    end)

    it("does nothing if not hidden", function()
      split = Split({
        size = 20,
        position = "bottom",
      })

      split:mount()

      local prev_winids = vim.api.nvim_list_wins()

      split:show()

      local curr_winids = vim.api.nvim_list_wins()

      eq(#prev_winids, #curr_winids)
    end)
  end)

  describe("method :update_layout", function()
    it("can change size", function()
      split = Split({ positon = "bottom", size = 10 })

      split:mount()

      eq(vim.api.nvim_win_get_height(split.winid), 10)

      split:update_layout({ size = 20 })

      eq(vim.api.nvim_win_get_height(split.winid), 20)
    end)

    it("can change position", function()
      local winid = vim.api.nvim_get_current_win()

      split = Split({ position = "bottom", size = 10 })

      split:mount()

      eq(vim.fn.winlayout(), {
        "col",
        {
          { "leaf", winid },
          { "leaf", split.winid },
        },
      })

      split:update_layout({ position = "right" })

      eq(vim.fn.winlayout(), {
        "row",
        {
          { "leaf", winid },
          { "leaf", split.winid },
        },
      })
    end)

    it("can change position and size", function()
      local winid = vim.api.nvim_get_current_win()

      split = Split({ position = "top", size = 10 })

      split:mount()

      eq(vim.api.nvim_win_get_height(split.winid), 10)
      eq(vim.fn.winlayout(), {
        "col",
        {
          { "leaf", split.winid },
          { "leaf", winid },
        },
      })

      split:update_layout({ position = "left", size = 20 })

      eq(vim.api.nvim_win_get_width(split.winid), 20)
      eq(vim.fn.winlayout(), {
        "row",
        {
          { "leaf", split.winid },
          { "leaf", winid },
        },
      })
    end)

    it("can change relative", function()
      local winid_one = vim.api.nvim_get_current_win()
      local split_two = Split({ position = "right", size = 10 })
      split_two:mount()

      split = Split({ relative = "win", position = "top", size = 10 })

      split:mount()

      eq(vim.api.nvim_win_get_height(split.winid), 10)
      eq(vim.fn.winlayout(), {
        "row",
        {
          { "leaf", winid_one },
          {
            "col",
            {
              { "leaf", split.winid },
              { "leaf", split_two.winid },
            },
          },
        },
      })

      split:update_layout({ position = "bottom", relative = "editor", size = "50%" })

      eq(vim.api.nvim_win_get_height(split.winid), percent(vim.o.lines - 1, 50))
      eq(vim.fn.winlayout(), {
        "col",
        {
          {
            "row",
            {
              { "leaf", winid_one },
              { "leaf", split_two.winid },
            },
          },
          { "leaf", split.winid },
        },
      })

      split_two:unmount()
    end)
  end)

  h.describe_flipping_feature("lua_keymap", "method :map", function()
    it("works before :mount", function()
      local callback = spy.new(function() end)

      split = Split({
        size = 20,
      })

      split:map("n", "l", function()
        callback()
      end)

      split:mount()

      feedkeys("l", "x")

      assert.spy(callback).called()
    end)

    it("works after :mount", function()
      local callback = spy.new(function() end)

      split = Split({
        size = 20,
      })

      split:mount()

      split:map("n", "l", function()
        callback()
      end)

      feedkeys("l", "x")

      assert.spy(callback).called()
    end)

    it("supports lhs table", function()
      split = Split({
        size = 20,
      })

      split:mount()

      split:map("n", { "k", "l" }, "o42<esc>")

      feedkeys("k", "x")
      feedkeys("l", "x")

      h.assert_buf_lines(split.bufnr, {
        "",
        "42",
        "42",
      })
    end)

    it("supports rhs function", function()
      local callback = spy.new(function() end)

      split = Split({
        size = 20,
      })

      split:mount()

      split:map("n", "l", function()
        callback()
      end)

      feedkeys("l", "x")

      assert.spy(callback).called()
    end)

    it("supports rhs string", function()
      split = Split({
        size = 20,
      })

      split:mount()

      split:map("n", "l", "o42<esc>")

      feedkeys("l", "x")

      h.assert_buf_lines(split.bufnr, {
        "",
        "42",
      })
    end)

    it("supports o.remap=true", function()
      split = Split({
        size = 20,
      })

      split:mount()

      split:map("n", "k", "o42<Esc>")
      split:map("n", "l", "k", { remap = true })

      feedkeys("k", "x")
      feedkeys("l", "x")

      h.assert_buf_lines(split.bufnr, {
        "",
        "42",
        "42",
      })
    end)

    it("supports o.remap=false", function()
      split = Split({
        size = 20,
      })

      split:mount()

      split:map("n", "k", "o42<Esc>")
      split:map("n", "l", "k", { remap = false })

      feedkeys("k", "x")
      feedkeys("l", "x")

      h.assert_buf_lines(split.bufnr, {
        "",
        "42",
      })
    end)

    it("throws if .bufnr is nil", function()
      split = Split({
        size = 20,
      })

      split.bufnr = nil

      local ok, result = pcall(function()
        split:map("n", "k", "o42<Esc>")
      end)

      eq(ok, false)
      eq(type(string.match(result, "buffer not found")), "string")
    end)
  end)

  h.describe_flipping_feature("lua_keymap", "method :unmap", function()
    it("works before :mount", function()
      split = Split({
        size = 20,
      })

      split:map("n", "l", "o42<esc>")

      split:unmap("n", "l")

      split:mount()

      feedkeys("l", "x")

      h.assert_buf_lines(split.bufnr, {
        "",
      })
    end)

    it("works after :mount", function()
      split = Split({
        size = 20,
      })

      split:mount()

      split:map("n", "l", "o42<esc>")

      split:unmap("n", "l")

      feedkeys("l", "x")

      h.assert_buf_lines(split.bufnr, {
        "",
      })
    end)

    it("supports lhs string", function()
      split = Split({
        size = 20,
      })

      split:mount()

      split:map("n", "l", "o42<esc>")

      split:unmap("n", "l")

      feedkeys("l", "x")

      h.assert_buf_lines(split.bufnr, {
        "",
      })
    end)

    it("supports lhs table", function()
      split = Split({
        size = 20,
      })

      split:mount()

      split:map("n", "k", "o42<esc>")
      split:map("n", "l", "o42<esc>")

      split:unmap("n", { "k", "l" })

      feedkeys("k", "x")
      feedkeys("l", "x")

      h.assert_buf_lines(split.bufnr, {
        "",
      })
    end)

    it("throws if .bufnr is nil", function()
      split = Split({
        size = 20,
      })

      split.bufnr = nil

      local ok, result = pcall(function()
        split:unmap("n", "l")
      end)

      eq(ok, false)
      eq(type(string.match(result, "buffer not found")), "string")
    end)
  end)

  h.describe_flipping_feature("lua_autocmd", "method :on", function()
    it("works before :mount", function()
      local callback = spy.new(function() end)

      split = Split({
        size = 20,
      })

      split:on(event.InsertEnter, function()
        callback()
      end)

      split:mount()

      feedkeys("i", "x")
      feedkeys("<esc>", "x")

      assert.spy(callback).called()
    end)

    it("works after :mount", function()
      local callback = spy.new(function() end)

      split = Split({
        size = 20,
      })

      split:mount()

      split:on(event.InsertEnter, function()
        callback()
      end)

      feedkeys("i", "x")
      feedkeys("<esc>", "x")

      assert.spy(callback).called()
    end)

    it("throws if .bufnr is nil", function()
      split = Split({
        size = 20,
      })

      split.bufnr = nil

      local ok, result = pcall(function()
        split:on(event.InsertEnter, function() end)
      end)

      eq(ok, false)
      eq(type(string.match(result, "buffer not found")), "string")
    end)
  end)

  h.describe_flipping_feature("lua_autocmd", "method :off", function()
    it("works before :mount", function()
      local callback = spy.new(function() end)

      split = Split({
        size = 20,
      })

      split:on(event.InsertEnter, function()
        callback()
      end)

      split:off(event.InsertEnter)

      split:mount()

      feedkeys("i", "x")
      feedkeys("<esc>", "x")

      assert.spy(callback).not_called()
    end)

    it("works after :mount", function()
      local callback = spy.new(function() end)

      split = Split({
        size = 20,
      })

      split:mount()

      split:on(event.InsertEnter, function()
        callback()
      end)

      split:off(event.InsertEnter)

      feedkeys("i", "x")
      feedkeys("<esc>", "x")

      assert.spy(callback).not_called()
    end)

    it("throws if .bufnr is nil", function()
      split = Split({
        size = 20,
      })

      split.bufnr = nil

      local ok, result = pcall(function()
        split:off()
      end)

      eq(ok, false)
      eq(type(string.match(result, "buffer not found")), "string")
    end)
  end)
end)

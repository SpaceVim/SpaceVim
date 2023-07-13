pcall(require, "luacov")

local ns_id = require("neo-tree.ui.highlights").ns_id
local u = require("tests.utils")

describe("ui/icons", function()
  local req_switch = u.get_require_switch()

  local test = u.fs.init_test({
    items = {
      {
        name = "foo",
        type = "dir",
        items = {
          {
            name = "bar",
            type = "dir",
            items = {
              { name = "bar1.txt", type = "file" },
              { name = "bar2.txt", type = "file" },
            },
          },
          { name = "foo1.lua", type = "file" },
        },
      },
      { name = "baz", type = "dir" },
      { name = "1.md", type = "file" },
    },
  })

  test.setup()

  local fs_tree = test.fs_tree

  after_each(function()
    if req_switch then
      req_switch.restore()
    end

    u.clear_environment()
  end)

  describe("w/ default_config", function()
    before_each(function()
      require("neo-tree").setup({})
    end)

    it("works w/o nvim-web-devicons", function()
      req_switch.disable_package("nvim-web-devicons")

      vim.cmd([[:Neotree focus]])
      u.wait_for(function()
        return vim.bo.filetype == "neo-tree"
      end)

      local winid = vim.api.nvim_get_current_win()
      local bufnr = vim.api.nvim_win_get_buf(winid)

      u.assert_buf_lines(bufnr, {
        string.format("  %s", fs_tree.abspath):sub(1, 42),
        "    baz",
        "    foo",
        "   * 1.md",
      })

      vim.api.nvim_win_set_cursor(winid, { 2, 0 })
      u.feedkeys("<CR>")

      vim.api.nvim_win_set_cursor(winid, { 3, 0 })
      u.feedkeys("<CR>")

      vim.wait(100)

      u.assert_buf_lines(bufnr, {
        string.format("  %s", fs_tree.abspath):sub(1, 42),
        "   ﰊ baz",
        "    foo",
        "   │  bar",
        "   └ * foo1.lua",
        "   * 1.md",
      })

      u.assert_highlight(bufnr, ns_id, 1, " ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 2, "ﰊ ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 4, " ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 5, "* ", "NeoTreeFileIcon")
    end)

    it("works w/ nvim-web-devicons", function()
      vim.cmd([[:Neotree focus]])
      u.wait_for(function()
        return vim.bo.filetype == "neo-tree"
      end)

      local winid = vim.api.nvim_get_current_win()
      local bufnr = vim.api.nvim_win_get_buf(winid)

      u.assert_buf_lines(bufnr, {
        vim.fn.strcharpart(string.format("  %s", fs_tree.abspath), 0, 40),
        "    baz",
        "    foo",
        "    1.md",
      })

      vim.api.nvim_win_set_cursor(winid, { 2, 0 })
      u.feedkeys("<CR>")

      vim.api.nvim_win_set_cursor(winid, { 3, 0 })
      u.feedkeys("<CR>")

      vim.wait(100)

      u.assert_buf_lines(bufnr, {
        vim.fn.strcharpart(string.format("  %s", fs_tree.abspath), 0, 40),
        "   ﰊ baz",
        "    foo",
        "   │  bar",
        "   └  foo1.lua",
        "    1.md",
      })

      u.assert_highlight(bufnr, ns_id, 1, " ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 2, "ﰊ ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 4, " ", "NeoTreeDirectoryIcon")

      local extmarks = u.get_text_extmarks(bufnr, ns_id, 5, " ")
      u.eq(#extmarks, 1)
      u.neq(extmarks[1][4].hl_group, "NeoTreeFileIcon")
    end)
  end)

  describe("custom config", function()
    local config
    before_each(function()
      config = {
        default_component_configs = {
          icon = {
            folder_closed = "c",
            folder_open = "o",
            folder_empty = "e",
            default = "f",
            highlight = "TestNeoTreeFileIcon",
          },
        },
      }

      require("neo-tree").setup(config)
    end)

    it("works w/o nvim-web-devicons", function()
      req_switch.disable_package("nvim-web-devicons")

      vim.cmd([[:Neotree focus]])
      u.wait_for(function()
        return vim.bo.filetype == "neo-tree"
      end)

      local winid = vim.api.nvim_get_current_win()
      local bufnr = vim.api.nvim_win_get_buf(winid)

      u.assert_buf_lines(bufnr, {
        string.format(" o %s", fs_tree.abspath):sub(1, 40),
        "   c baz",
        "   c foo",
        "   f 1.md",
      })

      vim.api.nvim_win_set_cursor(winid, { 2, 0 })
      u.feedkeys("<CR>")

      vim.api.nvim_win_set_cursor(winid, { 3, 0 })
      u.feedkeys("<CR>")

      vim.wait(100)

      u.assert_buf_lines(bufnr, {
        string.format(" o %s", fs_tree.abspath):sub(1, 40),
        "   e baz",
        "   o foo",
        "   │ c bar",
        "   └ f foo1.lua",
        "   f 1.md",
      })

      u.assert_highlight(bufnr, ns_id, 1, "o ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 2, "e ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 4, "c ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 5, "f ", config.default_component_configs.icon.highlight)
    end)

    it("works w/ nvim-web-devicons", function()
      vim.cmd([[:Neotree focus]])
      u.wait_for(function()
        return vim.bo.filetype == "neo-tree"
      end)

      local winid = vim.api.nvim_get_current_win()
      local bufnr = vim.api.nvim_win_get_buf(winid)

      u.assert_buf_lines(bufnr, {
        vim.fn.strcharpart(string.format(" o %s", fs_tree.abspath), 0, 40),
        "   c baz",
        "   c foo",
        "    1.md",
      })

      vim.api.nvim_win_set_cursor(winid, { 2, 0 })
      u.feedkeys("<CR>")

      vim.api.nvim_win_set_cursor(winid, { 3, 0 })
      u.feedkeys("<CR>")

      vim.wait(100)

      u.assert_buf_lines(bufnr, {
        vim.fn.strcharpart(string.format(" o %s", fs_tree.abspath), 0, 40),
        "   e baz",
        "   o foo",
        "   │ c bar",
        "   └  foo1.lua",
        "    1.md",
      })

      u.assert_highlight(bufnr, ns_id, 1, "o ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 2, "e ", "NeoTreeDirectoryIcon")
      u.assert_highlight(bufnr, ns_id, 4, "c ", "NeoTreeDirectoryIcon")

      local extmarks = u.get_text_extmarks(bufnr, ns_id, 5, " ")
      u.eq(#extmarks, 1)
      u.neq(extmarks[1][4].hl_group, config.default_component_configs.icon.highlight)
    end)
  end)

  test.teardown()
end)

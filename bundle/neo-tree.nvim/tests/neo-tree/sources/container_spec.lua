pcall(require, "luacov")

local ns_id = require("neo-tree.ui.highlights").ns_id
local u = require("tests.utils")

local config = {
  renderers = {
    directory = {
      {
        "container",
        content = {
          { "indent", zindex = 10 },
          { "icon", zindex = 10 },
          { "name", zindex = 10 },
          { "name", zindex = 5, align = "right" },
        },
      },
    },
    file = {
      {
        "container",
        content = {
          { "indent", zindex = 10 },
          { "icon", zindex = 10 },
          { "name", zindex = 10 },
          { "name", zindex = 20, align = "right" },
        },
      },
    },
  },
  window = {
    width = 40,
  },
}

local config_right = {
  renderers = {
    directory = {
      {
        "container",
        enable_character_fade = false,
        content = {
          { "indent", zindex = 10, align = "right" },
          { "icon", zindex = 10, align = "right" },
          { "name", zindex = 10, align = "right" },
        },
      },
    },
    file = {
      {
        "container",
        enable_character_fade = false,
        content = {
          { "indent", zindex = 10, align = "right" },
          { "icon", zindex = 10, align = "right" },
          { "name", zindex = 10, align = "right" },
        },
      },
    },
  },
  window = {
    width = 40,
  },
}

local test_dir = {
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
    { name = "bazbazbazbazbazbazbazbazbazbazbazbazbazbazbazbazbaz", type = "dir" },
    { name = "1.md", type = "file" },
  },
}

describe("sources/components/container", function()
  local req_switch = u.get_require_switch()

  local test = u.fs.init_test(test_dir)
  test.setup()

  after_each(function()
    if req_switch then
      req_switch.restore()
    end

    u.clear_environment()
  end)

  describe("should expand to width", function()
    for pow = 4, 8 do
      it(2 ^ pow, function()
        config.window.width = 2 ^ pow
        require("neo-tree").setup(config)
        vim.cmd([[Neotree focus]])
        u.wait_for(function()
          return vim.bo.filetype == "neo-tree"
        end)

        assert.equals(vim.bo.filetype, "neo-tree")

        local width = vim.api.nvim_win_get_width(0)
        local lines = vim.api.nvim_buf_get_lines(0, 2, -1, false)
        for _, line in ipairs(lines) do
          assert.is_true(#line >= width)
        end
      end)
    end
  end)

  describe("right-align should matches width", function()
    for pow = 4, 8 do
      it(2 ^ pow, function()
        config_right.window.width = 2 ^ pow
        require("neo-tree").setup(config_right)
        vim.cmd([[Neotree focus]])
        u.wait_for(function()
          return vim.bo.filetype == "neo-tree"
        end)

        assert.equals(vim.bo.filetype, "neo-tree")

        local width = vim.api.nvim_win_get_width(0)
        local lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
        for _, line in ipairs(lines) do
          line = vim.fn.trim(line, " ", 2)
          assert.equals(width, vim.fn.strchars(line))
        end
      end)
    end
  end)

  test.teardown()
end)

pcall(require, "luacov")

local u = require("tests.utils")
local verify = require("tests.utils.verify")

local run_focus_command = function(command, expected_tree_node)
  local winid = vim.api.nvim_get_current_win()

  vim.cmd(command)
  verify.window_handle_is_not(winid)
  verify.buf_name_endswith("neo-tree filesystem [1]")
  if expected_tree_node then
    verify.filesystem_tree_node_is(expected_tree_node)
  end
end

local run_show_command = function(command, expected_tree_node)
  local starting_winid = vim.api.nvim_get_current_win()
  local starting_bufname = vim.api.nvim_buf_get_name(0)
  local expected_num_windows = #vim.api.nvim_list_wins() + 1

  vim.cmd(command)
  verify.eventually(500, function()
    if #vim.api.nvim_list_wins() ~= expected_num_windows then
      return false
    end
    if vim.api.nvim_get_current_win() ~= starting_winid then
      return false
    end
    if vim.api.nvim_buf_get_name(0) ~= starting_bufname then
      return false
    end
    if expected_tree_node then
      verify.filesystem_tree_node_is(expected_tree_node)
    end
    return true
  end, "Expected to see a new window without focusing it.")
end

describe("Command", function()
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
              { name = "baz1.txt", type = "file" },
              { name = "baz2.txt", type = "file", id = "deepfile2" },
            },
          },
          { name = "foofile1.txt", type = "file" },
        },
      },
      { name = "topfile1.txt", type = "file", id = "topfile1" },
    },
  })

  test.setup()

  local fs_tree = test.fs_tree

  after_each(function()
    u.clear_environment()
  end)

  describe("with reveal:", function()
    it("`:Neotree float reveal` should reveal the current file in the floating window", function()
      local cmd = "Neotree float reveal"
      local testfile = fs_tree.lookup["./foo/bar/baz1.txt"].abspath
      u.editfile(testfile)
      run_focus_command(cmd, testfile)
    end)

    it("`:Neotree reveal toggle` should toggle the reveal-state of the tree", function()
      local cmd = "Neotree reveal toggle"
      local testfile = fs_tree.lookup["./foo/foofile1.txt"].abspath
      u.editfile(testfile)

      -- toggle OPEN
      run_focus_command(cmd, testfile)
      local tree_winid = vim.api.nvim_get_current_win()

      -- toggle CLOSE
      vim.cmd(cmd)
      verify.window_handle_is_not(tree_winid)
      verify.buf_name_is(testfile)

      -- toggle OPEN with a different file
      testfile = fs_tree.lookup["./foo/bar/baz1.txt"].abspath
      u.editfile(testfile)
      run_focus_command(cmd, testfile)
    end)

    it(
      "`:Neotree float reveal toggle` should toggle the reveal-state of the floating window",
      function()
        local cmd = "Neotree float reveal toggle"
        local testfile = fs_tree.lookup["./foo/foofile1.txt"].abspath
        u.editfile(testfile)

        -- toggle OPEN
        run_focus_command(cmd, testfile)
        local tree_winid = vim.api.nvim_get_current_win()

        -- toggle CLOSE
        vim.cmd("Neotree float reveal toggle")
        verify.window_handle_is_not(tree_winid)
        verify.buf_name_is(testfile)

        -- toggle OPEN
        testfile = fs_tree.lookup["./foo/bar/baz2.txt"].abspath
        u.editfile(testfile)
        run_focus_command(cmd, testfile)
      end
    )

    it("`:Neotree reveal` should reveal the current file in the sidebar", function()
      local cmd = "Neotree reveal"
      local testfile = fs_tree.lookup["topfile1"].abspath
      u.editfile(testfile)
      run_focus_command(cmd, testfile)
    end)
  end)

  for _, follow_current_file in ipairs({ true, false }) do
    require("neo-tree").setup({
      filesystem = {
        follow_current_file = follow_current_file,
      },
    })

    describe(string.format("w/ follow_current_file=%s", follow_current_file), function()
      describe("with show  :", function()
        it("`:Neotree show` should show the window without focusing", function()
          local cmd = "Neotree show"
          local testfile = fs_tree.lookup["topfile1"].abspath
          u.editfile(testfile)
          run_show_command(cmd)
        end)

        it("`:Neotree show toggle` should retain the focused node on next show", function()
          local cmd = "Neotree show toggle"
          local topfile = fs_tree.lookup["topfile1"].abspath
          local baz = fs_tree.lookup["./foo/bar/baz1.txt"].abspath

          -- focus a sub node to see if state is retained
          u.editfile(baz)
          run_focus_command(":Neotree reveal", baz)
          local expected_tree_node = baz

          verify.after(500, function()
            -- toggle CLOSE
            vim.cmd(cmd)

            -- toggle OPEN
            u.editfile(topfile)
            if follow_current_file then
              expected_tree_node = topfile
            end
            run_show_command(cmd, expected_tree_node)
            return true
          end)
        end)
      end)

      describe("with focus :", function()
        it("`:Neotree focus` should show the window and focus it", function()
          local cmd = "Neotree focus"
          local testfile = fs_tree.lookup["topfile1"].abspath
          u.editfile(testfile)
          run_focus_command(cmd)
        end)

        it("`:Neotree focus toggle` should retain the focused node on next focus", function()
          local cmd = "Neotree focus toggle"
          local topfile = fs_tree.lookup["topfile1"].abspath
          local baz = fs_tree.lookup["./foo/bar/baz1.txt"].abspath

          -- focus a sub node to see if state is retained
          u.editfile(baz)
          run_focus_command("Neotree reveal", baz)
          local expected_tree_node = baz

          verify.after(500, function()
            -- toggle CLOSE
            vim.cmd(cmd)

            -- toggle OPEN
            u.editfile(topfile)
            if follow_current_file then
              expected_tree_node = topfile
            end
            run_focus_command(cmd, expected_tree_node)
            return true
          end)
        end)
      end)
    end)
  end

  test.teardown()
end)

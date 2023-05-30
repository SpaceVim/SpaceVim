pcall(require, "luacov")

local u = require("tests.utils")
local verify = require("tests.utils.verify")

local manager = require('neo-tree.sources.manager')

local get_dirs = function(winid)
  winid = winid or vim.api.nvim_get_current_win()
  local tabnr = vim.api.nvim_tabpage_get_number(vim.api.nvim_win_get_tabpage(winid))
  local winnr = vim.api.nvim_win_get_number(winid)
  return {
    win = vim.fn.getcwd(winnr),
    tab = vim.fn.getcwd(-1, tabnr),
    global = vim.fn.getcwd(-1, -1),
  }
end

local get_state_for_tab = function(tabid)
  for _, state in ipairs(manager._get_all_states()) do
    if state.tabid == tabid then
      return state
    end
  end
end

local get_tabnr = function(tabid)
    return vim.api.nvim_tabpage_get_number(tabid or vim.api.nvim_get_current_tabpage())
end

describe("Manager", function()
  local test = u.fs.init_test({
    items = {
      {
        name = "foo",
        type = "dir",
        items = {
          { name = "foofile1.txt", type = "file" },
        },
      },
      { name = "topfile1.txt", type = "file", id = "topfile1" },
    },
  })

  test.setup()

  local fs_tree = test.fs_tree

  -- Just make sure we start all tests in the expected state
  before_each(function()
    u.eq(1, #vim.api.nvim_list_wins())
    u.eq(1, #vim.api.nvim_list_tabpages())
    vim.cmd.lcd(fs_tree.abspath)
    vim.cmd.tcd(fs_tree.abspath)
    vim.cmd.cd(fs_tree.abspath)
  end)

  after_each(function()
    u.clear_environment()
  end)

  local setup_2_tabs = function()
    -- create 2 tabs
    local tab1 = vim.api.nvim_get_current_tabpage()
    local win1 = vim.api.nvim_get_current_win()
    vim.cmd.tabnew()
    local tab2 = vim.api.nvim_get_current_tabpage()
    local win2 = vim.api.nvim_get_current_win()
    u.neq(tab2, tab1)
    u.neq(win2, win1)

    -- set different directories
    vim.api.nvim_set_current_tabpage(tab2)
    local base_dir = vim.fn.getcwd()
    vim.cmd.tcd('foo')
    local new_dir = vim.fn.getcwd()

    -- open neo-tree
    vim.api.nvim_set_current_tabpage(tab1)
    vim.cmd.Neotree('show')
    vim.api.nvim_set_current_tabpage(tab2)
    vim.cmd.Neotree('show')

    return {
      tab1 = tab1,
      tab2 = tab2,
      win1 = win1,
      win2 = win2,
      tab1_dir = base_dir,
      tab2_dir = new_dir,
    }
  end

  it("should respect changed tab cwd", function()
    local ctx = setup_2_tabs()

    local state1 = get_state_for_tab(ctx.tab1)
    local state2 = get_state_for_tab(ctx.tab2)
    u.eq(ctx.tab1_dir, manager.get_cwd(state1))
    u.eq(ctx.tab2_dir, manager.get_cwd(state2))
  end)

  it("should have correct tab cwd after  tabs order is changed", function()
    local ctx = setup_2_tabs()

    -- tab numbers should be the same as ids
    u.eq(1, get_tabnr(ctx.tab1))
    u.eq(2, get_tabnr(ctx.tab2))

    -- swap tabs
    vim.cmd.tabfirst()
    vim.cmd.tabmove('+1')

    -- make sure tabs have been swapped
    u.eq(2, get_tabnr(ctx.tab1))
    u.eq(1, get_tabnr(ctx.tab2))

    -- verify that tab dirs are the same as nvim tab cwd
    local state1 = get_state_for_tab(ctx.tab1)
    local state2 = get_state_for_tab(ctx.tab2)
    u.eq(get_dirs(ctx.win1).tab, manager.get_cwd(state1))
    u.eq(get_dirs(ctx.win2).tab, manager.get_cwd(state2))
  end)
end)


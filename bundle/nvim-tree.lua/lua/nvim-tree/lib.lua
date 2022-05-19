local api = vim.api

local renderer = require "nvim-tree.renderer"
local view = require "nvim-tree.view"
local core = require "nvim-tree.core"

local M = {
  target_winid = nil,
}

function M.get_nodes_by_line(nodes_all, line_start)
  local nodes_by_line = {}
  local line = line_start
  local function iter(nodes)
    for _, node in ipairs(nodes) do
      nodes_by_line[line] = node
      line = line + 1
      if node.open == true then
        local child = iter(node.nodes)
        if child ~= nil then
          return child
        end
      end
    end
  end
  iter(nodes_all)
  return nodes_by_line
end

function M.get_node_at_cursor()
  if not core.get_explorer() then
    return
  end
  local winnr = view.get_winnr()
  if not winnr then
    return
  end
  local cursor = api.nvim_win_get_cursor(view.get_winnr())
  local line = cursor[1]
  if view.is_help_ui() then
    local help_lines = require("nvim-tree.renderer.help").compute_lines()
    local help_text = M.get_nodes_by_line(help_lines, 1)[line]
    return { name = help_text }
  else
    if line == 1 and core.get_explorer().cwd ~= "/" and view.is_root_folder_visible() then
      return { name = ".." }
    end

    return M.get_nodes_by_line(core.get_explorer().nodes, core.get_nodes_starting_line())[line]
  end
end

-- If node is grouped, return the last node in the group. Otherwise, return the given node.
function M.get_last_group_node(node)
  local next = node
  while next.group_next do
    next = next.group_next
  end
  return next
end

function M.expand_or_collapse(node)
  node.open = not node.open
  if node.has_children then
    node.has_children = false
  end

  if #node.nodes == 0 then
    core.get_explorer():expand(node)
  end

  renderer.draw()
end

function M.set_target_win()
  local id = api.nvim_get_current_win()
  local tree_id = view.get_winnr()
  if tree_id and id == tree_id then
    M.target_winid = 0
    return
  end

  M.target_winid = id
end

local function handle_buf_cwd(cwd)
  local respect_buf_cwd = vim.g.nvim_tree_respect_buf_cwd or 0
  if respect_buf_cwd == 1 and cwd ~= core.get_explorer().cwd then
    require("nvim-tree.actions.change-dir").fn(cwd)
  end
end

local function open_view_and_draw()
  local cwd = vim.fn.getcwd()
  view.open()
  handle_buf_cwd(cwd)
  renderer.draw()
end

local function should_hijack_current_buf()
  local bufnr = api.nvim_get_current_buf()
  local bufname = api.nvim_buf_get_name(bufnr)
  local bufmodified = api.nvim_buf_get_option(bufnr, "modified")
  local ft = api.nvim_buf_get_option(bufnr, "ft")

  local should_hijack_unnamed = M.hijack_unnamed_buffer_when_opening and bufname == "" and not bufmodified and ft == ""
  local should_hijack_dir = bufname ~= "" and vim.fn.isdirectory(bufname) == 1 and M.hijack_directories.enable

  return should_hijack_dir or should_hijack_unnamed
end

function M.open(cwd)
  M.set_target_win()
  if not core.get_explorer() or cwd then
    core.init(cwd or vim.loop.cwd())
  end
  if should_hijack_current_buf() then
    view.open_in_current_win()
    renderer.draw()
  else
    open_view_and_draw()
  end
  view.restore_tab_state()
end

-- @deprecated: use nvim-tree.actions.collapse-all.fn
M.collapse_all = require("nvim-tree.actions.collapse-all").fn
-- @deprecated: use nvim-tree.actions.dir-up.fn
M.dir_up = require("nvim-tree.actions.dir-up").fn
-- @deprecated: use nvim-tree.actions.change-dir.fn
M.change_dir = require("nvim-tree.actions.change-dir").fn
-- @deprecated: use nvim-tree.actions.reloaders.reload_explorer
M.refresh_tree = require("nvim-tree.actions.reloaders").reload_explorer
-- @deprecated: use nvim-tree.actions.reloaders.reload_git
M.reload_git = require("nvim-tree.actions.reloaders").reload_git
-- @deprecated: use nvim-tree.actions.find-file.fn
M.set_index_and_redraw = require("nvim-tree.actions.find-file").fn

function M.setup(opts)
  M.hijack_unnamed_buffer_when_opening = opts.hijack_unnamed_buffer_when_opening
  M.hijack_directories = opts.hijack_directories
end

return M

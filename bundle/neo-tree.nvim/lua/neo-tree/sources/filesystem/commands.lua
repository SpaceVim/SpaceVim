--This file should contain all commands meant to be used by mappings.

local cc = require("neo-tree.sources.common.commands")
local fs = require("neo-tree.sources.filesystem")
local utils = require("neo-tree.utils")
local filter = require("neo-tree.sources.filesystem.lib.filter")
local renderer = require("neo-tree.ui.renderer")
local log = require("neo-tree.log")

local M = {}
local refresh = function(state)
  fs._navigate_internal(state, nil, nil, nil, false)
end

local redraw = function(state)
  renderer.redraw(state)
end

M.add = function(state)
  cc.add(state, utils.wrap(fs.show_new_children, state))
end

M.add_directory = function(state)
  cc.add_directory(state, utils.wrap(fs.show_new_children, state))
end

M.clear_filter = function(state)
  fs.reset_search(state, true)
end

M.copy = function(state)
  cc.copy(state, utils.wrap(refresh, state))
end

---Marks node as copied, so that it can be pasted somewhere else.
M.copy_to_clipboard = function(state)
  cc.copy_to_clipboard(state, utils.wrap(redraw, state))
end

M.copy_to_clipboard_visual = function(state, selected_nodes)
  cc.copy_to_clipboard_visual(state, selected_nodes, utils.wrap(redraw, state))
end

---Marks node as cut, so that it can be pasted (moved) somewhere else.
M.cut_to_clipboard = function(state)
  cc.cut_to_clipboard(state, utils.wrap(redraw, state))
end

M.cut_to_clipboard_visual = function(state, selected_nodes)
  cc.cut_to_clipboard_visual(state, selected_nodes, utils.wrap(redraw, state))
end

M.move = function(state)
  cc.move(state, utils.wrap(refresh, state))
end

---Pastes all items from the clipboard to the current directory.
M.paste_from_clipboard = function(state)
  cc.paste_from_clipboard(state, utils.wrap(fs.show_new_children, state))
end

M.delete = function(state)
  cc.delete(state, utils.wrap(refresh, state))
end

M.delete_visual = function(state, selected_nodes)
  cc.delete_visual(state, selected_nodes, utils.wrap(refresh, state))
end

M.expand_all_nodes = function(state)
  local toggle_dir_no_redraw = function(_state, node)
    fs.toggle_directory(_state, node, nil, true, true)
  end
  cc.expand_all_nodes(state, toggle_dir_no_redraw)
end

---Shows the filter input, which will filter the tree.
M.filter_as_you_type = function(state)
  filter.show_filter(state, true)
end

---Shows the filter input, which will filter the tree.
M.filter_on_submit = function(state)
  filter.show_filter(state, false)
end

---Shows the filter input in fuzzy finder mode.
M.fuzzy_finder = function(state)
  filter.show_filter(state, true, true)
end

---Shows the filter input in fuzzy finder mode.
M.fuzzy_finder_directory = function(state)
  filter.show_filter(state, true, "directory")
end

---Shows the filter input in fuzzy sorter
M.fuzzy_sorter = function(state)
  filter.show_filter(state, true, true, true)
end

---Shows the filter input in fuzzy sorter with only directories
M.fuzzy_sorter_directory = function(state)
  filter.show_filter(state, true, "directory", true)
end

---Navigate up one level.
M.navigate_up = function(state)
  local parent_path, _ = utils.split_path(state.path)
  if not utils.truthy(parent_path) then
    return
  end
  local path_to_reveal = nil
  local node = state.tree:get_node()
  if node then
    path_to_reveal = node:get_id()
  end
  if state.search_pattern then
    fs.reset_search(state, false)
  end
  log.debug("Changing directory to:", parent_path)
  fs._navigate_internal(state, parent_path, path_to_reveal, nil, false)
end

local focus_next_git_modified = function(state, reverse)
  local node = state.tree:get_node()
  local current_path = node:get_id()
  local g = state.git_status_lookup
  if not utils.truthy(g) then
    return
  end
  local paths = { current_path }
  for path, status in pairs(g) do
    if path ~= current_path and status and status ~= "!!" then
      --don't include files not in the current working directory
      if utils.is_subpath(state.path, path) then
        table.insert(paths, path)
      end
    end
  end
  local sorted_paths = utils.sort_by_tree_display(paths)
  if reverse then
    sorted_paths = utils.reverse_list(sorted_paths)
  end

  local is_file = function(path)
    local success, stats = pcall(vim.loop.fs_stat, path)
    return (success and stats and stats.type ~= "directory")
  end

  local passed = false
  local target = nil
  for _, path in ipairs(sorted_paths) do
    if target == nil and is_file(path) then
      target = path
    end
    if passed then
      if is_file(path) then
        target = path
        break
      end
    elseif path == current_path then
      passed = true
    end
  end

  local existing = state.tree:get_node(target)
  if existing then
    renderer.focus_node(state, target)
  else
    fs.navigate(state, state.path, target, nil, false)
  end
end

M.next_git_modified = function(state)
  focus_next_git_modified(state, false)
end

M.prev_git_modified = function(state)
  focus_next_git_modified(state, true)
end

M.open = function(state)
  cc.open(state, utils.wrap(fs.toggle_directory, state))
end
M.open_split = function(state)
  cc.open_split(state, utils.wrap(fs.toggle_directory, state))
end
M.open_vsplit = function(state)
  cc.open_vsplit(state, utils.wrap(fs.toggle_directory, state))
end
M.open_tabnew = function(state)
  cc.open_tabnew(state, utils.wrap(fs.toggle_directory, state))
end
M.open_drop = function(state)
  cc.open_drop(state, utils.wrap(fs.toggle_directory, state))
end
M.open_tab_drop = function(state)
  cc.open_tab_drop(state, utils.wrap(fs.toggle_directory, state))
end

M.open_with_window_picker = function(state)
  cc.open_with_window_picker(state, utils.wrap(fs.toggle_directory, state))
end
M.split_with_window_picker = function(state)
  cc.split_with_window_picker(state, utils.wrap(fs.toggle_directory, state))
end
M.vsplit_with_window_picker = function(state)
  cc.vsplit_with_window_picker(state, utils.wrap(fs.toggle_directory, state))
end

M.refresh = refresh

M.rename = function(state)
  cc.rename(state, utils.wrap(refresh, state))
end

M.set_root = function(state)
  local tree = state.tree
  local node = tree:get_node()
  if node.type == "directory" then
    if state.search_pattern then
      fs.reset_search(state, false)
    end
    fs._navigate_internal(state, node.id, nil, nil, false)
  end
end

---Toggles whether hidden files are shown or not.
M.toggle_hidden = function(state)
  state.filtered_items.visible = not state.filtered_items.visible
  log.info("Toggling hidden files: " .. tostring(state.filtered_items.visible))
  refresh(state)
end

---Toggles whether the tree is filtered by gitignore or not.
M.toggle_gitignore = function(state)
  log.warn("`toggle_gitignore` has been removed, running toggle_hidden instead.")
  M.toggle_hidden(state)
end

M.toggle_node = function(state)
  cc.toggle_node(state, utils.wrap(fs.toggle_directory, state))
end

cc._add_common_commands(M)

return M

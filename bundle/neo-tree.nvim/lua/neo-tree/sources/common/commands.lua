--This file should contain all commands meant to be used by mappings.

local vim = vim
local fs_actions = require("neo-tree.sources.filesystem.lib.fs_actions")
local utils = require("neo-tree.utils")
local renderer = require("neo-tree.ui.renderer")
local events = require("neo-tree.events")
local inputs = require("neo-tree.ui.inputs")
local popups = require("neo-tree.ui.popups")
local log = require("neo-tree.log")
local help = require("neo-tree.sources.common.help")
local Preview = require("neo-tree.sources.common.preview")

---Gets the node parent folder
---@param state table to look for nodes
---@return table? node
local function get_folder_node(state)
  local tree = state.tree
  local node = tree:get_node()
  local last_id = node:get_id()

  while node do
    local insert_as_local = state.config.insert_as
    local insert_as_global = require("neo-tree").config.window.insert_as
    local use_parent
    if insert_as_local then
      use_parent = insert_as_local == "sibling"
    else
      use_parent = insert_as_global == "sibling"
    end

    local is_open_dir = node.type == "directory" and (node:is_expanded() or node.empty_expanded)
    if use_parent and not is_open_dir then
      return tree:get_node(node:get_parent_id())
    end

    if node.type == "directory" then
      return node
    end

    local parent_id = node:get_parent_id()
    if not parent_id or parent_id == last_id then
      return node
    else
      last_id = parent_id
      node = tree:get_node(parent_id)
    end
  end
end

---The using_root_directory is used to decide what part of the filename to show
-- the user when asking for a new filename to e.g. create, copy to or move to.
---@param state table The state of the source
---@return string The root path from which the relative source path should be taken
local function get_using_root_directory(state)
  -- default to showing only the basename of the path
  local using_root_directory = get_folder_node(state):get_id()
  local show_path = state.config.show_path
  if show_path == "absolute" then
    using_root_directory = ""
  elseif show_path == "relative" then
    using_root_directory = state.path
  elseif show_path ~= nil and show_path ~= "none" then
    log.warn(
      'A neo-tree mapping was setup with a config.show_path option with invalid value: "'
        .. show_path
        .. '", falling back to its default: nil/"none"'
    )
  end
  return using_root_directory
end

local M = {}

---Adds all missing common commands to the given module
---@param to_source_command_module table The commands module for a source
---@param pattern string? A pattern specifying which commands to add, nil to add all
M._add_common_commands = function(to_source_command_module, pattern)
  for name, func in pairs(M) do
    if
      type(name) == "string"
      and not to_source_command_module[name]
      and (not pattern or name:find(pattern))
      and not name:find("^_")
    then
      to_source_command_module[name] = func
    end
  end
end

---Add a new file or dir at the current node
---@param state table The state of the source
---@param callback function The callback to call when the command is done. Called with the parent node as the argument.
M.add = function(state, callback)
  local node = get_folder_node(state)
  local in_directory = node:get_id()
  local using_root_directory = get_using_root_directory(state)
  fs_actions.create_node(in_directory, callback, using_root_directory)
end

---Add a new file or dir at the current node
---@param state table The state of the source
---@param callback function The callback to call when the command is done. Called with the parent node as the argument.
M.add_directory = function(state, callback)
  local node = get_folder_node(state)
  local in_directory = node:get_id()
  local using_root_directory = get_using_root_directory(state)
  fs_actions.create_directory(in_directory, callback, using_root_directory)
end

M.expand_all_nodes = function(state, toggle_directory)
  if toggle_directory == nil then
    toggle_directory = function(_, node)
      node:expand()
    end
  end
  --state.explicitly_opened_directories = state.explicitly_opened_directories or {}

  local expand_node
  expand_node = function(node)
    local id = node:get_id()
    if node.type == "directory" and not node:is_expanded() then
      toggle_directory(state, node)
      node = state.tree:get_node(id)
    end
    local children = state.tree:get_nodes(id)
    if children then
      for _, child in ipairs(children) do
        if child.type == "directory" then
          expand_node(child)
        end
      end
    end
  end

  for _, node in ipairs(state.tree:get_nodes()) do
    expand_node(node)
  end
  renderer.redraw(state)
end

M.close_node = function(state, callback)
  local tree = state.tree
  local node = tree:get_node()
  local parent_node = tree:get_node(node:get_parent_id())
  local target_node

  if node:has_children() and node:is_expanded() then
    target_node = node
  else
    target_node = parent_node
  end

  local root = tree:get_nodes()[1]
  local is_root = target_node:get_id() == root:get_id()

  if target_node and target_node:has_children() and not is_root then
    target_node:collapse()
    renderer.redraw(state)
    renderer.focus_node(state, target_node:get_id())
  end
end

M.close_all_subnodes = function(state)
  local tree = state.tree
  local node = tree:get_node()
  local parent_node = tree:get_node(node:get_parent_id())
  local target_node

  if node:has_children() and node:is_expanded() then
    target_node = node
  else
    target_node = parent_node
  end

  renderer.collapse_all_nodes(tree, target_node:get_id())
  renderer.redraw(state)
  renderer.focus_node(state, target_node:get_id())
end

M.close_all_nodes = function(state)
  renderer.collapse_all_nodes(state.tree)
  renderer.redraw(state)
end

M.close_window = function(state)
  renderer.close(state)
end

M.toggle_auto_expand_width = function(state)
  if state.window.position == "float" then
    return
  end
  state.window.auto_expand_width = state.window.auto_expand_width == false
  local width = utils.resolve_width(state.window.width)
  if not state.window.auto_expand_width then
    if (state.window.last_user_width or width) >= vim.api.nvim_win_get_width(0) then
      state.window.last_user_width = width
    end
    vim.api.nvim_win_set_width(0, state.window.last_user_width)
    state.win_width = state.window.last_user_width
    state.longest_width_exact = 0
    log.trace(string.format("Collapse auto_expand_width."))
  end
  renderer.redraw(state)
end

local copy_node_to_clipboard = function(state, node)
  state.clipboard = state.clipboard or {}
  local existing = state.clipboard[node.id]
  if existing and existing.action == "copy" then
    state.clipboard[node.id] = nil
  else
    state.clipboard[node.id] = { action = "copy", node = node }
    log.info("Copied " .. node.name .. " to clipboard")
  end
end

---Marks node as copied, so that it can be pasted somewhere else.
M.copy_to_clipboard = function(state, callback)
  local node = state.tree:get_node()
  if node.type == "message" then
    return
  end
  copy_node_to_clipboard(state, node)
  if callback then
    callback()
  end
end

M.copy_to_clipboard_visual = function(state, selected_nodes, callback)
  for _, node in ipairs(selected_nodes) do
    if node.type ~= "message" then
      copy_node_to_clipboard(state, node)
    end
  end
  if callback then
    callback()
  end
end

local cut_node_to_clipboard = function(state, node)
  state.clipboard = state.clipboard or {}
  local existing = state.clipboard[node.id]
  if existing and existing.action == "cut" then
    state.clipboard[node.id] = nil
  else
    state.clipboard[node.id] = { action = "cut", node = node }
    log.info("Cut " .. node.name .. " to clipboard")
  end
end

---Marks node as cut, so that it can be pasted (moved) somewhere else.
M.cut_to_clipboard = function(state, callback)
  local node = state.tree:get_node()
  cut_node_to_clipboard(state, node)
  if callback then
    callback()
  end
end

M.cut_to_clipboard_visual = function(state, selected_nodes, callback)
  for _, node in ipairs(selected_nodes) do
    if node.type ~= "message" then
      cut_node_to_clipboard(state, node)
    end
  end
  if callback then
    callback()
  end
end

--------------------------------------------------------------------------------
-- Git commands
--------------------------------------------------------------------------------

M.git_add_file = function(state)
  local node = state.tree:get_node()
  if node.type == "message" then
    return
  end
  local path = node:get_id()
  local cmd = { "git", "add", path }
  vim.fn.system(cmd)
  events.fire_event(events.GIT_EVENT)
end

M.git_add_all = function(state)
  local cmd = { "git", "add", "-A" }
  vim.fn.system(cmd)
  events.fire_event(events.GIT_EVENT)
end

M.git_commit = function(state, and_push)
  local width = vim.fn.winwidth(0) - 2
  local row = vim.api.nvim_win_get_height(0) - 3
  local popup_options = {
    relative = "win",
    position = {
      row = row,
      col = 0,
    },
    size = width,
  }

  inputs.input("Commit message: ", "", function(msg)
    local cmd = { "git", "commit", "-m", msg }
    local title = "git commit"
    local result = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "fatal:")) then
      popups.alert("ERROR: git commit", result)
      return
    end
    if and_push then
      title = "git commit && git push"
      cmd = { "git", "push" }
      local result2 = vim.fn.systemlist(cmd)
      table.insert(result, "")
      for i = 1, #result2 do
        table.insert(result, result2[i])
      end
    end
    events.fire_event(events.GIT_EVENT)
    popups.alert(title, result)
  end, popup_options)
end

M.git_commit_and_push = function(state)
  M.git_commit(state, true)
end

M.git_push = function(state)
  inputs.confirm("Are you sure you want to push your changes?", function(yes)
    if yes then
      local result = vim.fn.systemlist({ "git", "push" })
      events.fire_event(events.GIT_EVENT)
      popups.alert("git push", result)
    end
  end)
end

M.git_unstage_file = function(state)
  local node = state.tree:get_node()
  if node.type == "message" then
    return
  end
  local path = node:get_id()
  local cmd = { "git", "reset", "--", path }
  vim.fn.system(cmd)
  events.fire_event(events.GIT_EVENT)
end

M.git_revert_file = function(state)
  local node = state.tree:get_node()
  if node.type == "message" then
    return
  end
  local path = node:get_id()
  local cmd = { "git", "checkout", "HEAD", "--", path }
  local msg = string.format("Are you sure you want to revert %s?", node.name)
  inputs.confirm(msg, function(yes)
    if yes then
      vim.fn.system(cmd)
      events.fire_event(events.GIT_EVENT)
    end
  end)
end

--------------------------------------------------------------------------------
-- END Git commands
--------------------------------------------------------------------------------

M.next_source = function(state)
  local sources = require("neo-tree").config.sources
  local sources = require("neo-tree").config.source_selector.sources
  local next_source = sources[1]
  for i, source_info in ipairs(sources) do
    if source_info.source == state.name then
      next_source = sources[i + 1]
      if not next_source then
        next_source = sources[1]
      end
      break
    end
  end

  require("neo-tree.command").execute({
    source = next_source.source,
    position = state.current_position,
    action = "focus",
  })
end

M.prev_source = function(state)
  local sources = require("neo-tree").config.sources
  local sources = require("neo-tree").config.source_selector.sources
  local next_source = sources[#sources]
  for i, source_info in ipairs(sources) do
    if source_info.source == state.name then
      next_source = sources[i - 1]
      if not next_source then
        next_source = sources[#sources]
      end
      break
    end
  end

  require("neo-tree.command").execute({
    source = next_source.source,
    position = state.current_position,
    action = "focus",
  })
end

M.show_debug_info = function(state)
  print(vim.inspect(state))
end

---Pastes all items from the clipboard to the current directory.
---@param state table The state of the source
---@param callback function The callback to call when the command is done. Called with the parent node as the argument.
M.paste_from_clipboard = function(state, callback)
  if state.clipboard then
    local folder = get_folder_node(state):get_id()
    -- Convert to list so to make it easier to pop items from the stack.
    local clipboard_list = {}
    for _, item in pairs(state.clipboard) do
      table.insert(clipboard_list, item)
    end
    state.clipboard = nil
    local handle_next_paste, paste_complete

    paste_complete = function(source, destination)
      if callback then
        local insert_as = require("neo-tree").config.window.insert_as
        -- open the folder so the user can see the new files
        local node = insert_as == "sibling" and state.tree:get_node() or state.tree:get_node(folder)
        if not node then
          log.warn("Could not find node for " .. folder)
        end
        callback(node, destination)
      end
      local next_item = table.remove(clipboard_list)
      if next_item then
        handle_next_paste(next_item)
      end
    end

    handle_next_paste = function(item)
      if item.action == "copy" then
        fs_actions.copy_node(
          item.node.path,
          folder .. utils.path_separator .. item.node.name,
          paste_complete
        )
      elseif item.action == "cut" then
        fs_actions.move_node(
          item.node.path,
          folder .. utils.path_separator .. item.node.name,
          paste_complete
        )
      end
    end

    local next_item = table.remove(clipboard_list)
    if next_item then
      handle_next_paste(next_item)
    end
  end
end

---Copies a node to a new location, using typed input.
---@param state table The state of the source
---@param callback function The callback to call when the command is done. Called with the parent node as the argument.
M.copy = function(state, callback)
  local node = state.tree:get_node()
  if node.type == "message" then
    return
  end
  local using_root_directory = get_using_root_directory(state)
  fs_actions.copy_node(node.path, nil, callback, using_root_directory)
end

---Moves a node to a new location, using typed input.
---@param state table The state of the source
---@param callback function The callback to call when the command is done. Called with the parent node as the argument.
M.move = function(state, callback)
  local node = state.tree:get_node()
  if node.type == "message" then
    return
  end
  local using_root_directory = get_using_root_directory(state)
  fs_actions.move_node(node.path, nil, callback, using_root_directory)
end

M.delete = function(state, callback)
  local tree = state.tree
  local node = tree:get_node()
  if node.type == "file" or node.type == "directory" then
    fs_actions.delete_node(node.path, callback)
  else
    log.warn("The `delete` command can only be used on files and directories")
  end
end

M.delete_visual = function(state, selected_nodes, callback)
  local paths_to_delete = {}
  for _, node_to_delete in pairs(selected_nodes) do
    if node_to_delete.type == "file" or node_to_delete.type == "directory" then
      table.insert(paths_to_delete, node_to_delete.path)
    end
  end
  fs_actions.delete_nodes(paths_to_delete, callback)
end

M.preview = function(state)
  Preview.show(state)
end

M.revert_preview = function()
  Preview.hide()
end
--
-- Multi-purpose function to back out of whatever we are in
M.cancel = function(state)
  if Preview.is_active() then
    Preview.hide()
  else
    if state.current_position == "float" then
      renderer.close_all_floating_windows()
    end
  end
end

M.toggle_preview = function(state)
  Preview.toggle(state)
end

M.focus_preview = function()
  Preview.focus()
end

---Open file or directory
---@param state table The state of the source
---@param open_cmd string The vim command to use to open the file
---@param toggle_directory function The function to call to toggle a directory
---open/closed
local open_with_cmd = function(state, open_cmd, toggle_directory, open_file)
  local tree = state.tree
  local success, node = pcall(tree.get_node, tree)
  if node.type == "message" then
    return
  end
  if not (success and node) then
    log.debug("Could not get node.")
    return
  end

  local function open()
    M.revert_preview()
    local path = node.path or node:get_id()
    local bufnr = node.extra and node.extra.bufnr
    if node.type == "terminal" then
      path = node:get_id()
    end
    if type(open_file) == "function" then
      open_file(state, path, open_cmd, bufnr)
    else
      utils.open_file(state, path, open_cmd, bufnr)
    end
    local extra = node.extra or {}
    local pos = extra.position or extra.end_position
    if pos ~= nil then
      vim.api.nvim_win_set_cursor(0, { (pos[1] or 0) + 1, pos[2] or 0 })
      vim.api.nvim_win_call(0, function()
        vim.cmd("normal! zvzz") -- expand folds and center cursor
      end)
    end
  end

  if utils.is_expandable(node) then
    if toggle_directory and node.type == "directory" then
      toggle_directory(node)
    elseif node:has_children() then
      if node:is_expanded() and node.type ~= "directory" then
        return open()
      end

      local updated = false
      if node:is_expanded() then
        updated = node:collapse()
      else
        updated = node:expand()
      end
      if updated then
        renderer.redraw(state)
      end
    end
  else
    open()
  end
end

---Open file or directory in the closest window
---@param state table The state of the source
---@param toggle_directory function The function to call to toggle a directory
---open/closed
M.open = function(state, toggle_directory)
  open_with_cmd(state, "e", toggle_directory)
end

---Open file or directory in a split of the closest window
---@param state table The state of the source
---@param toggle_directory function The function to call to toggle a directory
---open/closed
M.open_split = function(state, toggle_directory)
  open_with_cmd(state, "split", toggle_directory)
end

---Open file or directory in a vertical split of the closest window
---@param state table The state of the source
---@param toggle_directory function The function to call to toggle a directory
---open/closed
M.open_vsplit = function(state, toggle_directory)
  open_with_cmd(state, "vsplit", toggle_directory)
end

---Open file or directory in a new tab
---@param state table The state of the source
---@param toggle_directory function The function to call to toggle a directory
---open/closed
M.open_tabnew = function(state, toggle_directory)
  open_with_cmd(state, "tabnew", toggle_directory)
end

---Open file or directory or focus it if a buffer already exists with it
---@param state table The state of the source
---@param toggle_directory function The function to call to toggle a directory
---open/closed
M.open_drop = function(state, toggle_directory)
  open_with_cmd(state, "drop", toggle_directory)
end

---Open file or directory in new tab or focus it if a buffer already exists with it
---@param state table The state of the source
---@param toggle_directory function The function to call to toggle a directory
---open/closed
M.open_tab_drop = function(state, toggle_directory)
  open_with_cmd(state, "tab drop", toggle_directory)
end

M.rename = function(state, callback)
  local tree = state.tree
  local node = tree:get_node()
  if node.type == "message" then
    return
  end
  fs_actions.rename_node(node.path, callback)
end

---Expands or collapses the current node.
M.toggle_node = function(state, toggle_directory)
  local tree = state.tree
  local node = tree:get_node()
  if not utils.is_expandable(node) then
    return
  end
  if node.type == "directory" and toggle_directory then
    toggle_directory(node)
  elseif node:has_children() then
    local updated = false
    if node:is_expanded() then
      updated = node:collapse()
    else
      updated = node:expand()
    end
    if updated then
      renderer.redraw(state)
    end
  end
end

---Expands or collapses the current node.
M.toggle_directory = function(state, toggle_directory)
  local tree = state.tree
  local node = tree:get_node()
  if node.type ~= "directory" then
    return
  end
  M.toggle_node(state, toggle_directory)
end

---Marks potential windows with letters and will open the give node in the picked window.
---@param state table The state of the source
---@param path string The path to open
---@param cmd string Command that is used to perform action on picked window
local use_window_picker = function(state, path, cmd)
  local success, picker = pcall(require, "window-picker")
  if not success then
    print(
      "You'll need to install window-picker to use this command: https://github.com/s1n7ax/nvim-window-picker"
    )
    return
  end
  local events = require("neo-tree.events")
  local event_result = events.fire_event(events.FILE_OPEN_REQUESTED, {
    state = state,
    path = path,
    open_cmd = cmd,
  }) or {}
  if event_result.handled then
    events.fire_event(events.FILE_OPENED, path)
    return
  end
  local picked_window_id = picker.pick_window()
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
    local result, err = pcall(vim.cmd, cmd .. " " .. vim.fn.fnameescape(path))
    if result or err == "Vim(edit):E325: ATTENTION" then
      -- fixes #321
      vim.api.nvim_buf_set_option(0, "buflisted", true)
      events.fire_event(events.FILE_OPENED, path)
    else
      log.error("Error opening file:", err)
    end
  end
end

---Marks potential windows with letters and will open the give node in the picked window.
M.open_with_window_picker = function(state, toggle_directory)
  open_with_cmd(state, "edit", toggle_directory, use_window_picker)
end

---Marks potential windows with letters and will open the give node in a split next to the picked window.
M.split_with_window_picker = function(state, toggle_directory)
  open_with_cmd(state, "split", toggle_directory, use_window_picker)
end

---Marks potential windows with letters and will open the give node in a vertical split next to the picked window.
M.vsplit_with_window_picker = function(state, toggle_directory)
  open_with_cmd(state, "vsplit", toggle_directory, use_window_picker)
end

M.show_help = function(state)
  help.show(state)
end

return M

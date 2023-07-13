--This file should contain all commands meant to be used by mappings.

local vim = vim
local cc = require("neo-tree.sources.common.commands")
local buffers = require("neo-tree.sources.buffers")
local utils = require("neo-tree.utils")
local manager = require("neo-tree.sources.manager")

local M = {}

local refresh = utils.wrap(manager.refresh, "buffers")
local redraw = utils.wrap(manager.redraw, "buffers")

M.add = function(state)
  cc.add(state, refresh)
end

M.add_directory = function(state)
  cc.add_directory(state, refresh)
end

M.buffer_delete = function(state)
  local node = state.tree:get_node()
  if node then
    if node.type == "message" then
      return
    end
    vim.api.nvim_buf_delete(node.extra.bufnr, { force = false, unload = false })
    refresh()
  end
end

---Marks node as copied, so that it can be pasted somewhere else.
M.copy_to_clipboard = function(state)
  cc.copy_to_clipboard(state, redraw)
end

M.copy_to_clipboard_visual = function(state, selected_nodes)
  cc.copy_to_clipboard_visual(state, selected_nodes, redraw)
end

---Marks node as cut, so that it can be pasted (moved) somewhere else.
M.cut_to_clipboard = function(state)
  cc.cut_to_clipboard(state, redraw)
end

M.cut_to_clipboard_visual = function(state, selected_nodes)
  cc.cut_to_clipboard_visual(state, selected_nodes, redraw)
end

M.copy = function(state)
  cc.copy(state, redraw)
end

M.move = function(state)
  cc.move(state, redraw)
end

M.show_debug_info = cc.show_debug_info

---Pastes all items from the clipboard to the current directory.
M.paste_from_clipboard = function(state)
  cc.paste_from_clipboard(state, refresh)
end

M.delete = function(state)
  cc.delete(state, refresh)
end

---Navigate up one level.
M.navigate_up = function(state)
  local parent_path, _ = utils.split_path(state.path)
  buffers.navigate(state, parent_path)
end

M.refresh = refresh

M.rename = function(state)
  cc.rename(state, refresh)
end

M.set_root = function(state)
  local tree = state.tree
  local node = tree:get_node()
  if node.type == "directory" then
    buffers.navigate(state, node.id)
  end
end

cc._add_common_commands(M)

return M

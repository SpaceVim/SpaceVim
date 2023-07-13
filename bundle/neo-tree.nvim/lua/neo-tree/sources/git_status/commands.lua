--This file should contain all commands meant to be used by mappings.

local vim = vim
local cc = require("neo-tree.sources.common.commands")
local utils = require("neo-tree.utils")
local manager = require("neo-tree.sources.manager")

local M = {}

local refresh = utils.wrap(manager.refresh, "git_status")
local redraw = utils.wrap(manager.redraw, "git_status")

-- ----------------------------------------------------------------------------
-- Common commands
-- ----------------------------------------------------------------------------
M.add = function(state)
  cc.add(state, refresh)
end

M.add_directory = function(state)
  cc.add_directory(state, refresh)
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

---Pastes all items from the clipboard to the current directory.
M.paste_from_clipboard = function(state)
  cc.paste_from_clipboard(state, refresh)
end

M.delete = function(state)
  cc.delete(state, refresh)
end

M.delete_visual = function(state, selected_nodes)
  cc.delete_visual(state, selected_nodes, refresh)
end

M.refresh = refresh

M.rename = function(state)
  cc.rename(state, refresh)
end

cc._add_common_commands(M)

return M

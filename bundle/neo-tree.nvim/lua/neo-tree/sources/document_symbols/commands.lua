--This file should contain all commands meant to be used by mappings.
local cc = require("neo-tree.sources.common.commands")
local utils = require("neo-tree.utils")
local manager = require("neo-tree.sources.manager")
local inputs = require("neo-tree.ui.inputs")
local filters = require("neo-tree.sources.common.filters")

local vim = vim

local M = {}
local SOURCE_NAME = "document_symbols"
M.refresh = utils.wrap(manager.refresh, SOURCE_NAME)
M.redraw = utils.wrap(manager.redraw, SOURCE_NAME)

M.show_debug_info = function(state)
  print(vim.inspect(state))
end

M.jump_to_symbol = function(state, node)
  node = node or state.tree:get_node()
  if node:get_depth() == 1 then
    return
  end
  vim.api.nvim_set_current_win(state.lsp_winid)
  vim.api.nvim_set_current_buf(state.lsp_bufnr)
  local symbol_loc = node.extra.selection_range.start
  vim.api.nvim_win_set_cursor(state.lsp_winid, { symbol_loc[1] + 1, symbol_loc[2] })
end

M.rename = function(state)
  local node = state.tree:get_node()
  if node:get_depth() == 1 then
    return
  end
  local old_name = node.name

  local callback = function(new_name)
    if not new_name or new_name == "" or new_name == old_name then
      return
    end
    M.jump_to_symbol(state, node)
    vim.lsp.buf.rename(new_name)
    M.refresh(state)
  end
  local msg = string.format('Enter new name for "%s":', old_name)
  inputs.input(msg, old_name, callback)
end

M.open = M.jump_to_symbol

M.filter_on_submit = function(state)
  filters.show_filter(state, true, true)
end

M.filter = function(state)
  filters.show_filter(state, true)
end

cc._add_common_commands(M, "node") -- common tree commands
cc._add_common_commands(M, "^open") -- open commands
cc._add_common_commands(M, "^close_window$")
cc._add_common_commands(M, "source$") -- source navigation
cc._add_common_commands(M, "preview") -- preview
cc._add_common_commands(M, "^cancel$") -- cancel
cc._add_common_commands(M, "help") -- help commands
cc._add_common_commands(M, "with_window_picker$") -- open using window picker
cc._add_common_commands(M, "^toggle_auto_expand_width$")

return M

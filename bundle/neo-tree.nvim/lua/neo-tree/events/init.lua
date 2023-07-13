local vim = vim
local q = require("neo-tree.events.queue")
local log = require("neo-tree.log")
local utils = require("neo-tree.utils")

local M = {
  -- Well known event names, you can make up your own
  BEFORE_RENDER = "before_render",
  AFTER_RENDER = "after_render",
  FILE_ADDED = "file_added",
  FILE_DELETED = "file_deleted",
  BEFORE_FILE_MOVE = "before_file_move",
  FILE_MOVED = "file_moved",
  FILE_OPEN_REQUESTED = "file_open_requested",
  FILE_OPENED = "file_opened",
  BEFORE_FILE_RENAME = "before_file_rename",
  FILE_RENAMED = "file_renamed",
  FS_EVENT = "fs_event",
  GIT_EVENT = "git_event",
  GIT_STATUS_CHANGED = "git_status_changed",
  NEO_TREE_BUFFER_ENTER = "neo_tree_buffer_enter",
  NEO_TREE_BUFFER_LEAVE = "neo_tree_buffer_leave",
  NEO_TREE_LSP_UPDATE = "neo_tree_lsp_update",
  NEO_TREE_POPUP_BUFFER_ENTER = "neo_tree_popup_buffer_enter",
  NEO_TREE_POPUP_BUFFER_LEAVE = "neo_tree_popup_buffer_leave",
  NEO_TREE_WINDOW_AFTER_CLOSE = "neo_tree_window_after_close",
  NEO_TREE_WINDOW_AFTER_OPEN = "neo_tree_window_after_open",
  NEO_TREE_WINDOW_BEFORE_CLOSE = "neo_tree_window_before_close",
  NEO_TREE_WINDOW_BEFORE_OPEN = "neo_tree_window_before_open",
  VIM_AFTER_SESSION_LOAD = "vim_after_session_load",
  VIM_BUFFER_ADDED = "vim_buffer_added",
  VIM_BUFFER_CHANGED = "vim_buffer_changed",
  VIM_BUFFER_DELETED = "vim_buffer_deleted",
  VIM_BUFFER_ENTER = "vim_buffer_enter",
  VIM_BUFFER_MODIFIED_SET = "vim_buffer_modified_set",
  VIM_COLORSCHEME = "vim_colorscheme",
  VIM_CURSOR_MOVED = "vim_cursor_moved",
  VIM_DIAGNOSTIC_CHANGED = "vim_diagnostic_changed",
  VIM_DIR_CHANGED = "vim_dir_changed",
  VIM_INSERT_LEAVE = "vim_insert_leave",
  VIM_LEAVE = "vim_leave",
  VIM_LSP_REQUEST = "vim_lsp_request",
  VIM_RESIZED = "vim_resized",
  VIM_TAB_CLOSED = "vim_tab_closed",
  VIM_TERMINAL_ENTER = "vim_terminal_enter",
  VIM_TEXT_CHANGED_NORMAL = "vim_text_changed_normal",
  VIM_WIN_CLOSED = "vim_win_closed",
  VIM_WIN_ENTER = "vim_win_enter",
}

M.define_autocmd_event = function(event_name, autocmds, debounce_frequency, seed_fn, nested)
  local opts = {
    setup = function()
      local tpl =
        ":lua require('neo-tree.events').fire_event('%s', { afile = vim.fn.expand('<afile>') })"
      local callback = string.format(tpl, event_name)
      if nested then
        callback = "++nested " .. callback
      end

      local autocmd = table.concat(autocmds, ",")
      if not vim.startswith(autocmd, "User") then
        autocmd = autocmd .. " *"
      end
      local cmds = {
        "augroup NeoTreeEvent_" .. event_name,
        "autocmd " .. autocmd .. " " .. callback,
        "augroup END",
      }
      log.trace("Registering autocmds: %s", table.concat(cmds, "\n"))
      vim.cmd(table.concat(cmds, "\n"))
    end,
    seed = seed_fn,
    teardown = function()
      log.trace("Teardown autocmds for ", event_name)
      vim.cmd(string.format("autocmd! NeoTreeEvent_%s", event_name))
    end,
    debounce_frequency = debounce_frequency,
    debounce_strategy = utils.debounce_strategy.CALL_LAST_ONLY,
  }
  log.debug("Defining autocmd event: %s", event_name)
  q.define_event(event_name, opts)
end

M.clear_all_events = q.clear_all_events
M.define_event = q.define_event
M.destroy_event = q.destroy_event
M.fire_event = q.fire_event

M.subscribe = q.subscribe
M.unsubscribe = q.unsubscribe

return M

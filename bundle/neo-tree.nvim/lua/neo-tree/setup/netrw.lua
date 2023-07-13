local utils = require("neo-tree.utils")
local log = require("neo-tree.log")
local manager = require("neo-tree.sources.manager")
local command = require("neo-tree.command")
local M = {}

local get_position = function(source_name)
  local nt = require("neo-tree")
  local pos = utils.get_value(nt.config, source_name .. ".window.position", "left", true)
  return pos
end

M.get_hijack_netrw_behavior = function()
  local nt = require("neo-tree")
  local option = "filesystem.hijack_netrw_behavior"
  local hijack_behavior = utils.get_value(nt.config, option, "open_default", true)
  if hijack_behavior == "disabled" then
    return hijack_behavior
  elseif hijack_behavior == "open_default" then
    return hijack_behavior
  elseif hijack_behavior == "open_current" then
    return hijack_behavior
  else
    log.error("Invalid value for " .. option .. ": " .. hijack_behavior)
    return "disabled"
  end
end

M.hijack = function()
  local hijack_behavior = M.get_hijack_netrw_behavior()
  if hijack_behavior == "disabled" then
    return false
  end

  -- ensure this is a directory
  local bufname = vim.api.nvim_buf_get_name(0)
  local stats = vim.loop.fs_stat(bufname)
  if not stats then
    return false
  end
  if stats.type ~= "directory" then
    return false
  end

  -- record where we are now
  local pos = get_position("filesystem")
  local should_open_current = hijack_behavior == "open_current" or pos == "current"
  local winid = vim.api.nvim_get_current_win()
  local dir_bufnr = vim.api.nvim_get_current_buf()

  -- Now actually open the tree, with a very quick debounce because this may be
  -- called multiple times in quick succession.
  utils.debounce("hijack_netrw_" .. winid, function()
    -- We will want to replace the "directory" buffer with either the "alternate"
    -- buffer or a new blank one.
    local replace_with_bufnr = vim.fn.bufnr("#")
    local is_currently_neo_tree = false
    if replace_with_bufnr > 0 then
      if vim.api.nvim_buf_get_option(replace_with_bufnr, "filetype") == "neo-tree" then
        -- don't hijack the current window if it's already a Neo-tree sidebar
        local _, position = pcall(vim.api.nvim_buf_get_var, replace_with_bufnr, "neo_tree_position")
        if position ~= "current" then
          is_currently_neo_tree = true
        else
          replace_with_bufnr = -1
        end
      end
    end
    if not should_open_current then
      if replace_with_bufnr == dir_bufnr or replace_with_bufnr < 1 then
        replace_with_bufnr = vim.api.nvim_create_buf(true, false)
        log.trace("Created new buffer for netrw hijack", replace_with_bufnr)
      end
    end
    if replace_with_bufnr > 0 then
      log.trace("Replacing buffer in netrw hijack", replace_with_bufnr)
      pcall(vim.api.nvim_win_set_buf, winid, replace_with_bufnr)
    end
    local remove_dir_buf = vim.schedule_wrap(function()
      log.trace("Deleting buffer in netrw hijack", dir_bufnr)
      pcall(vim.api.nvim_buf_delete, dir_bufnr, { force = true })
    end)

    local state
    if should_open_current and not is_currently_neo_tree then
      log.debug("hijack_netrw: opening current")
      state = manager.get_state("filesystem", nil, winid)
      state.current_position = "current"
    elseif is_currently_neo_tree then
      log.debug("hijack_netrw: opening in existing Neo-tree")
      state = manager.get_state("filesystem")
    else
      log.debug("hijack_netrw: opening default")
      manager.close_all_except("filesystem")
      state = manager.get_state("filesystem")
    end
    require("neo-tree.sources.filesystem")._navigate_internal(state, bufname, nil, remove_dir_buf)
  end, 10, utils.debounce_strategy.CALL_LAST_ONLY)

  return true
end

return M

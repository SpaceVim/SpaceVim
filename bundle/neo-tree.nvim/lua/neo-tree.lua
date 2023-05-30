local vim = vim
local utils = require("neo-tree.utils")
local renderer = require("neo-tree.ui.renderer")
local log = require("neo-tree.log")
local manager = require("neo-tree.sources.manager")
local setup = require("neo-tree.setup")

-- If you add a new source, you need to add it to the sources table.
-- Each source should have a defaults module that contains the default values
-- for the source config, and a setup function that takes that config.
local sources = {
  "filesystem",
  "buffers",
  "git_status",
}

local M = {}

local check_source = function(source_name)
  if not utils.truthy(source_name) then
    source_name = M.config.default_source
  end
  local success, result = pcall(require, "neo-tree.sources." .. source_name)
  if not success then
    error("Source " .. source_name .. " could not be loaded: ", result)
  end
  return source_name
end

local get_position = function(source_name)
  local pos = utils.get_value(M, "config." .. source_name .. ".window.position", "left", false)
  return pos
end

M.ensure_config = function()
  if not M.config then
    M.setup({ log_to_file = false }, true)
  end
end

--DEPRECATED in v2.x
M.close_all_except = function(source_name)
  -- this entire function is faulty now that position can be overriden at runtime
  source_name = check_source(source_name)
  local target_pos = get_position(source_name)
  for _, name in ipairs(sources) do
    if name ~= source_name then
      local pos = utils.get_value(M, "config." .. name .. ".window.position", "left", false)
      if pos == target_pos then
        manager.close(name)
      end
    end
  end
  renderer.close_all_floating_windows()
end

--DEPRECATED in v2.x
M.close = manager.close

--DEPRECATED in v2.x, use manager.close_all()
M.close_all = function(at_position)
  renderer.close_all_floating_windows()
  if type(at_position) == "string" and at_position > "" then
    for _, name in ipairs(sources) do
      local pos = get_position(name)
      if pos == at_position then
        manager.close(name)
      end
    end
  else
    for _, name in ipairs(sources) do
      manager.close(name)
    end
  end
end

--DEPRECATED in v2.x, use commands.execute()
M.float = function(source_name, toggle_if_open)
  M.ensure_config()
  source_name = check_source(source_name)
  if toggle_if_open then
    if renderer.close_floating_window(source_name) then
      -- It was open, and now it's not.
      return
    end
  end
  renderer.close_all_floating_windows()
  manager.close(source_name) -- in case this source is open in a sidebar
  manager.float(source_name)
end

--DEPRECATED in v2.x, use commands.execute()
M.focus = function(source_name, close_others, toggle_if_open)
  M.ensure_config()
  source_name = check_source(source_name)
  if get_position(source_name) == "current" then
    M.show_in_split(source_name, toggle_if_open)
    return
  end

  if toggle_if_open then
    if manager.close(source_name) then
      -- It was open, and now it's not.
      return
    end
  end
  if close_others == nil then
    close_others = true
  end
  if close_others then
    M.close_all_except(source_name)
  end
  manager.focus(source_name)
end

--DEPRECATED in v2.x, use commands.execute()
M.reveal_current_file = function(source_name, toggle_if_open, force_cwd)
  M.ensure_config()
  source_name = check_source(source_name)
  if get_position(source_name) == "current" then
    M.reveal_in_split(source_name, toggle_if_open)
    return
  end
  if toggle_if_open then
    if manager.close(source_name) then
      -- It was open, and now it's not.
      return
    end
  end
  manager.reveal_current_file(source_name, nil, force_cwd)
end

--DEPRECATED in v2.x, use commands.execute()
M.reveal_in_split = function(source_name, toggle_if_open)
  M.ensure_config()
  source_name = check_source(source_name)
  if toggle_if_open then
    local state = manager.get_state(source_name, nil, vim.api.nvim_get_current_win())
    if renderer.close(state) then
      -- It was open, and now it's not.
      return
    end
  end
  --TODO: if we are currently in a sidebar, don't replace it with a split style
  manager.reveal_in_split(source_name)
end

--DEPRECATED in v2.x, use commands.execute()
M.show_in_split = function(source_name, toggle_if_open)
  M.ensure_config()
  source_name = check_source(source_name)
  if toggle_if_open then
    local state = manager.get_state(source_name, nil, vim.api.nvim_get_current_win())
    if renderer.close(state) then
      -- It was open, and now it's not.
      return
    end
  end
  --TODO: if we are currently in a sidebar, don't replace it with a split style
  manager.show_in_split(source_name)
end

M.get_prior_window = function(ignore_filetypes)
  ignore_filetypes = ignore_filetypes or {}
  local ignore = utils.list_to_dict(ignore_filetypes)
  ignore["neo-tree"] = true

  local tabid = vim.api.nvim_get_current_tabpage()
  local wins = utils.get_value(M, "config.prior_windows", {}, true)[tabid]
  if wins == nil then
    return -1
  end
  local win_index = #wins
  while win_index > 0 do
    local last_win = wins[win_index]
    if type(last_win) == "number" then
      local success, is_valid = pcall(vim.api.nvim_win_is_valid, last_win)
      if success and is_valid then
        local buf = vim.api.nvim_win_get_buf(last_win)
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
        local bt = vim.api.nvim_buf_get_option(buf, "buftype") or "normal"
        if ignore[ft] ~= true and ignore[bt] ~= true then
          return last_win
        end
      end
    end
    win_index = win_index - 1
  end
  return -1
end

M.paste_default_config = function()
  local base_path = debug.getinfo(utils.truthy).source:match("@(.*)/utils.lua$")
  local config_path = base_path .. utils.path_separator .. "defaults.lua"
  local lines = vim.fn.readfile(config_path)
  if lines == nil then
    error("Could not read neo-tree.defaults")
  end

  -- read up to the end of the config, jut to omit the final return
  local config = {}
  for _, line in ipairs(lines) do
    table.insert(config, line)
    if line == "}" then
      break
    end
  end

  vim.api.nvim_put(config, "l", true, false)
  vim.schedule(function()
    vim.cmd("normal! `[v`]=")
  end)
end

M.buffer_enter_event = setup.buffer_enter_event
M.win_enter_event = setup.win_enter_event

--DEPRECATED in v2.x
--BREAKING CHANGE: Removed the do_not_focus and close_others options in 2.0
--M.show = function(source_name, do_not_focus, close_others, toggle_if_open)
M.show = function(source_name, toggle_if_open)
  M.ensure_config()
  source_name = check_source(source_name)
  if get_position(source_name) == "current" then
    M.show_in_split(source_name, toggle_if_open)
    return
  end

  if toggle_if_open then
    if manager.close(source_name) then
      -- It was open, and now it's not.
      return
    end
  end

  M.close_all_except(source_name)
  manager.show(source_name)
end

M.set_log_level = function(level)
  log.set_level(level)
end

M.setup = function(config, is_auto_config)
  M.config = require("neo-tree.setup").merge_config(config, is_auto_config)
  local netrw = require("neo-tree.setup.netrw")
  if not is_auto_config and netrw.get_hijack_netrw_behavior() ~= "disabled" then
    vim.cmd("silent! autocmd! FileExplorer *")
    netrw.hijack()
  end
end

M.show_logs = function()
  vim.cmd("tabnew " .. log.outfile)
end

return M

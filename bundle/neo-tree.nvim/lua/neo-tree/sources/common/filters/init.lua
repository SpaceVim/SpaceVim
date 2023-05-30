---A generalization of the filter functionality to directly filter the
---source tree instead of relying on pre-filtered data, which is specific
---to the filesystem source.
local vim = vim
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local popups = require("neo-tree.ui.popups")
local renderer = require("neo-tree.ui.renderer")
local utils = require("neo-tree.utils")
local log = require("neo-tree.log")
local manager = require("neo-tree.sources.manager")
local fzy = require("neo-tree.sources.common.filters.filter_fzy")

local M = {}

local cmds = {
  move_cursor_down = function(state, scroll_padding)
    renderer.focus_node(state, nil, true, 1, scroll_padding)
  end,

  move_cursor_up = function(state, scroll_padding)
    renderer.focus_node(state, nil, true, -1, scroll_padding)
    vim.cmd("redraw!")
  end,
}

---Reset the current filter to the empty string.
---@param state any
---@param refresh boolean? whether to refresh the source tree
---@param open_current_node boolean? whether to open the current node
local reset_filter = function(state, refresh, open_current_node)
  log.trace("reset_search")
  if refresh == nil then
    refresh = true
  end

  -- Cancel any pending search
  require("neo-tree.sources.filesystem.lib.filter_external").cancel()

  -- reset search state
  if state.open_folders_before_search then
    state.force_open_folders = vim.deepcopy(state.open_folders_before_search, { noref = 1 })
  else
    state.force_open_folders = nil
  end
  state.open_folders_before_search = nil
  state.search_pattern = nil

  if open_current_node then
    local success, node = pcall(state.tree.get_node, state.tree)
    if success and node then
      local id = node:get_id()
      renderer.position.set(state, id)
      id = utils.remove_trailing_slash(id)
      manager.navigate(state, nil, id, utils.wrap(pcall, renderer.focus_node, state, id, false))
    end
  elseif refresh then
    manager.navigate(state)
  else
    state.tree = vim.deepcopy(state.orig_tree)
  end
  state.orig_tree = nil
end

---Show the filtered tree
---@param state any
---@param do_not_focus_window boolean? whether to focus the window
local show_filtered_tree = function(state, do_not_focus_window)
  state.tree = vim.deepcopy(state.orig_tree)
  state.tree:get_nodes()[1].search_pattern = state.search_pattern
  local max_score, max_id = fzy.get_score_min(), nil
  local function filter_tree(node_id)
    local node = state.tree:get_node(node_id)
    local path = node.extra.search_path or node.path

    local should_keep = fzy.has_match(state.search_pattern, path)
    if should_keep then
      local score = fzy.score(state.search_pattern, path)
      node.extra.fzy_score = score
      if score > max_score then
        max_score = score
        max_id = node_id
      end
    end

    if node:has_children() then
      for _, child_id in ipairs(node:get_child_ids()) do
        should_keep = filter_tree(child_id) or should_keep
      end
    end
    if not should_keep then
      state.tree:remove_node(node_id) -- TODO: this might not be efficient
    end
    return should_keep
  end
  if #state.search_pattern > 0 then
    for _, root in ipairs(state.tree:get_nodes()) do
      filter_tree(root:get_id())
    end
  end
  manager.redraw(state.name)
  if max_id then
    renderer.focus_node(state, max_id, do_not_focus_window)
  end
end

---Main entry point for the filter functionality.
---This will display a filter input popup and filter the source tree on change and on submit
---@param state table the source state
---@param search_as_you_type boolean? whether to filter as you type or only on submit
---@param keep_filter_on_submit boolean? whether to keep the filter on <CR> or reset it
M.show_filter = function(state, search_as_you_type, keep_filter_on_submit)
  local winid = vim.api.nvim_get_current_win()
  local height = vim.api.nvim_win_get_height(winid)
  local scroll_padding = 3

  -- setup the input popup options
  local popup_msg = "Search:"
  if search_as_you_type then
    popup_msg = "Filter:"
  end

  local width = vim.fn.winwidth(0) - 2
  local row = height - 3
  if state.current_position == "float" then
    scroll_padding = 0
    width = vim.fn.winwidth(winid)
    row = height - 2
    vim.api.nvim_win_set_height(winid, row)
  end

  state.orig_tree = vim.deepcopy(state.tree)

  local popup_options = popups.popup_options(popup_msg, width, {
    relative = "win",
    winid = winid,
    position = {
      row = row,
      col = 0,
    },
    size = width,
  })

  local has_pre_search_folders = utils.truthy(state.open_folders_before_search)
  if not has_pre_search_folders then
    log.trace("No search or pre-search folders, recording pre-search folders now")
    state.open_folders_before_search = renderer.get_expanded_nodes(state.tree)
  end

  local waiting_for_default_value = utils.truthy(state.search_pattern)
  local input = Input(popup_options, {
    prompt = " ",
    default_value = state.search_pattern,
    on_submit = function(value)
      if value == "" then
        reset_filter(state)
        return
      end
      if search_as_you_type and not keep_filter_on_submit then
        reset_filter(state, true, true)
        return
      end
      -- do the search
      state.search_pattern = value
      show_filtered_tree(state, false)
    end,
    --this can be bad in a deep folder structure
    on_change = function(value)
      if not search_as_you_type then
        return
      end
      -- apparently when a default value is set, on_change fires for every character
      if waiting_for_default_value then
        if #value < #state.search_pattern then
          return
        end
        waiting_for_default_value = false
      end
      if value == state.search_pattern or value == nil then
        return
      end

      -- finally do the search
      log.trace("Setting search in on_change to: " .. value)
      state.search_pattern = value
      local len_to_delay = { [0] = 500, 500, 400, 200 }
      local delay = len_to_delay[#value] or 100

      utils.debounce(state.name .. "_filter", function()
        show_filtered_tree(state, true)
      end, delay, utils.debounce_strategy.CALL_LAST_ONLY)
    end,
  })

  input:mount()

  local restore_height = vim.schedule_wrap(function()
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_set_height(winid, height)
    end
  end)

  -- create mappings and autocmd
  input:map("i", "<C-w>", "<C-S-w>", { noremap = true })
  input:map("i", "<esc>", function(bufnr)
    vim.cmd("stopinsert")
    input:unmount()
    if utils.truthy(state.search_pattern) then
      reset_filter(state, true)
    end
    restore_height()
  end, { noremap = true })

  local config = require("neo-tree").config
  for lhs, cmd_name in pairs(config.filesystem.window.fuzzy_finder_mappings) do
    local cmd = cmds[cmd_name]
    if cmd then
      input:map("i", lhs, utils.wrap(cmd, state, scroll_padding), { noremap = true })
    else
      log.warn(string.format("Invalid command in fuzzy_finder_mappings: %s = %s", lhs, cmd_name))
    end
  end
end

return M

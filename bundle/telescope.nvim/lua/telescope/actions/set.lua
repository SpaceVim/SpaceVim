---@tag telescope.actions.set
---@config { ["module"] = "telescope.actions.set", ["name"] = "ACTIONS_SET" }

---@brief [[
--- Telescope action sets are used to provide an interface for managing
--- actions that all primarily do the same thing, but with slight tweaks.
---
--- For example, when editing files you may want it in the current split,
--- a vertical split, etc. Instead of making users have to overwrite EACH
--- of those every time they want to change this behavior, they can instead
--- replace the `set` itself and then it will work great and they're done.
---@brief ]]

local a = vim.api

local log = require "telescope.log"
local Path = require "plenary.path"
local state = require "telescope.state"
local utils = require "telescope.utils"

local action_state = require "telescope.actions.state"

local transform_mod = require("telescope.actions.mt").transform_mod

local action_set = setmetatable({}, {
  __index = function(_, k)
    error("'telescope.actions.set' does not have a value: " .. tostring(k))
  end,
})

--- Move the current selection of a picker {change} rows.
--- Handles not overflowing / underflowing the list.
---@param prompt_bufnr number: The prompt bufnr
---@param change number: The amount to shift the selection by
action_set.shift_selection = function(prompt_bufnr, change)
  local count = vim.v.count
  count = count == 0 and 1 or count
  count = a.nvim_get_mode().mode == "n" and count or 1
  action_state.get_current_picker(prompt_bufnr):move_selection(change * count)
end

--- Select the current entry. This is the action set to overwrite common
--- actions by the user.
---
--- By default maps to editing a file.
---@param prompt_bufnr number: The prompt bufnr
---@param type string: The type of selection to make
--          Valid types include: "default", "horizontal", "vertical", "tabedit"
action_set.select = function(prompt_bufnr, type)
  return action_set.edit(prompt_bufnr, action_state.select_key_to_edit_key(type))
end

-- goal: currently we have a workaround in actions/init.lua where we do this for all files
-- action_set.select = {
--   -- Will not be called if `select_default` is replaced rather than `action_set.select` because we never get here
--   pre = function(prompt_bufnr)
--     action_state.get_current_history():append(
--       action_state.get_current_line(),
--       action_state.get_current_picker(prompt_bufnr)
--     )
--   end,
--   action = function(prompt_bufnr, type)
--     return action_set.edit(prompt_bufnr, action_state.select_key_to_edit_key(type))
--   end
-- }

local edit_buffer
do
  local map = {
    drop = "drop",
    ["tab drop"] = "tab drop",
    edit = "buffer",
    new = "sbuffer",
    vnew = "vert sbuffer",
    tabedit = "tab sb",
  }

  edit_buffer = function(command, bufnr)
    command = map[command]
    if command == nil then
      error "There was no associated buffer command"
    end
    if command ~= "drop" and command ~= "tab drop" then
      vim.cmd(string.format("%s %d", command, bufnr))
    else
      vim.cmd(string.format("%s %s", command, vim.api.nvim_buf_get_name(bufnr)))
    end
  end
end

--- Edit a file based on the current selection.
---@param prompt_bufnr number: The prompt bufnr
---@param command string: The command to use to open the file.
--      Valid commands include: "edit", "new", "vedit", "tabedit"
action_set.edit = function(prompt_bufnr, command)
  local entry = action_state.get_selected_entry()

  if not entry then
    utils.notify("actions.set.edit", {
      msg = "Nothing currently selected",
      level = "WARN",
    })
    return
  end

  local filename, row, col

  if entry.path or entry.filename then
    filename = entry.path or entry.filename

    -- TODO: Check for off-by-one
    row = entry.row or entry.lnum
    col = vim.F.if_nil(entry.col, 1)
  elseif not entry.bufnr then
    -- TODO: Might want to remove this and force people
    -- to put stuff into `filename`
    local value = entry.value
    if not value then
      utils.notify("actions.set.edit", {
        msg = "Could not do anything with blank line...",
        level = "WARN",
      })
      return
    end

    if type(value) == "table" then
      value = entry.display
    end

    local sections = vim.split(value, ":")

    filename = sections[1]
    row = tonumber(sections[2])
    col = tonumber(sections[3])
  end

  local entry_bufnr = entry.bufnr

  local picker = action_state.get_current_picker(prompt_bufnr)
  require("telescope.pickers").on_close_prompt(prompt_bufnr)
  pcall(vim.api.nvim_set_current_win, picker.original_win_id)
  local win_id = picker.get_selection_window(picker, entry)

  if picker.push_cursor_on_edit then
    vim.cmd "normal! m'"
  end

  if picker.push_tagstack_on_edit then
    local from = { vim.fn.bufnr "%", vim.fn.line ".", vim.fn.col ".", 0 }
    local items = { { tagname = vim.fn.expand "<cword>", from = from } }
    vim.fn.settagstack(vim.fn.win_getid(), { items = items }, "t")
  end

  if win_id ~= 0 and a.nvim_get_current_win() ~= win_id then
    vim.api.nvim_set_current_win(win_id)
  end

  if entry_bufnr then
    if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
      vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
    end
    edit_buffer(command, entry_bufnr)
  else
    -- check if we didn't pick a different buffer
    -- prevents restarting lsp server
    if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
      filename = Path:new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
      pcall(vim.cmd, string.format("%s %s", command, filename))
    end
  end

  if row and col then
    local ok, err_msg = pcall(a.nvim_win_set_cursor, 0, { row, col })
    if not ok then
      log.debug("Failed to move to cursor:", err_msg, row, col)
    end
  end
end

--- Scrolls the previewer up or down.
--- Defaults to a half page scroll, but can be overridden using the `scroll_speed`
--- option in `layout_config`. See |telescope.layout| for more details.
---@param prompt_bufnr number: The prompt bufnr
---@param direction number: The direction of the scrolling
--      Valid directions include: "1", "-1"
action_set.scroll_previewer = function(prompt_bufnr, direction)
  local previewer = action_state.get_current_picker(prompt_bufnr).previewer
  local status = state.get_status(prompt_bufnr)

  -- Check if we actually have a previewer and a preview window
  if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then
    return
  end

  local default_speed = vim.api.nvim_win_get_height(status.preview_win) / 2
  local speed = status.picker.layout_config.scroll_speed or default_speed

  previewer:scroll_fn(math.floor(speed * direction))
end

--- Scrolls the results up or down.
--- Defaults to a half page scroll, but can be overridden using the `scroll_speed`
--- option in `layout_config`. See |telescope.layout| for more details.
---@param prompt_bufnr number: The prompt bufnr
---@param direction number: The direction of the scrolling
--      Valid directions include: "1", "-1"
action_set.scroll_results = function(prompt_bufnr, direction)
  local status = state.get_status(prompt_bufnr)
  local default_speed = vim.api.nvim_win_get_height(status.results_win) / 2
  local speed = status.picker.layout_config.scroll_speed or default_speed

  local input = direction > 0 and [[]] or [[]]

  vim.api.nvim_win_call(status.results_win, function()
    vim.cmd([[normal! ]] .. math.floor(speed) .. input)
  end)

  action_set.shift_selection(prompt_bufnr, math.floor(speed) * direction)
end

-- ==================================================
-- Transforms modules and sets the corect metatables.
-- ==================================================
action_set = transform_mod(action_set)
return action_set

---@tag telescope.actions.state
---@config { ["module"] = "telescope.actions.state", ["name"] = "ACTIONS_STATE" }

---@brief [[
--- Functions to be used to determine the current state of telescope.
---
--- Generally used from within other |telescope.actions|
---@brief ]]

local global_state = require "telescope.state"
local conf = require("telescope.config").values

local action_state = {}

--- Get the current entry
function action_state.get_selected_entry()
  return global_state.get_global_key "selected_entry"
end

--- Gets the current line
function action_state.get_current_line()
  return global_state.get_global_key "current_line" or ""
end

--- Gets the current picker
---@param prompt_bufnr number: The prompt bufnr
function action_state.get_current_picker(prompt_bufnr)
  return global_state.get_status(prompt_bufnr).picker
end

local select_to_edit_map = {
  default = "edit",
  horizontal = "new",
  vertical = "vnew",
  tab = "tabedit",
  drop = "drop",
  ["tab drop"] = "tab drop",
}
function action_state.select_key_to_edit_key(type)
  return select_to_edit_map[type]
end

function action_state.get_current_history()
  local history = global_state.get_global_key "history"
  if not history then
    if conf.history == false or type(conf.history) ~= "table" then
      history = require("telescope.actions.history").get_simple_history()
      global_state.set_global_key("history", history)
    else
      history = conf.history.handler()
      global_state.set_global_key("history", history)
    end
  end

  return history
end

return action_state

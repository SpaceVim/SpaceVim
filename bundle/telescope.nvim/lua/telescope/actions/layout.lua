---@tag telescope.actions.layout
---@config { ["module"] = "telescope.actions.layout", ["name"] = "ACTIONS_LAYOUT" }

---@brief [[
--- The layout actions are actions to be used to change the layout of a picker.
---@brief ]]

local action_state = require "telescope.actions.state"
local state = require "telescope.state"
local layout_strats = require "telescope.pickers.layout_strategies"

local transform_mod = require("telescope.actions.mt").transform_mod

local action_layout = setmetatable({}, {
  __index = function(_, k)
    error("'telescope.actions.layout' does not have a value: " .. tostring(k))
  end,
})

--- Toggle preview window.
--- - Note: preview window can be toggled even if preview is set to false.
---
--- This action is not mapped by default.
---@param prompt_bufnr number: The prompt bufnr
action_layout.toggle_preview = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local status = state.get_status(picker.prompt_bufnr)

  if picker.previewer and status.preview_win then
    picker.hidden_previewer = picker.previewer
    picker.previewer = nil
  elseif picker.hidden_previewer and not status.preview_win then
    picker.previewer = picker.hidden_previewer
    picker.hidden_previewer = nil
  else
    return
  end
  picker:full_layout_update()
end

-- TODO IMPLEMENT (mentored project available, contact @l-kershaw)
action_layout.toggle_padding = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  -- if padding ~= 0
  --    1. Save `height` and `width` of picker
  --    2. Set both to `{padding = 0}`
  -- else
  --    1. Lookup previous `height` and `width` of picker
  --    2. Set both to previous values
  picker:full_layout_update()
end

--- Toggles the `prompt_position` option between "top" and "bottom".
--- Checks if `prompt_position` is an option for the current layout.
---
--- This action is not mapped by default.
---@param prompt_bufnr number: The prompt bufnr
action_layout.toggle_prompt_position = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  picker.layout_config = picker.layout_config or {}
  picker.layout_config[picker.layout_strategy] = picker.layout_config[picker.layout_strategy] or {}
  -- flex layout is weird and needs handling separately
  if picker.layout_strategy == "flex" then
    picker.layout_config.flex.horizontal = picker.layout_config.flex.horizontal or {}
    picker.layout_config.flex.vertical = picker.layout_config.flex.vertical or {}
    local old_pos = picker.layout_config.flex[picker.__flex_strategy].prompt_position
    local new_pos = old_pos == "top" and "bottom" or "top"
    picker.layout_config[picker.__flex_strategy].prompt_position = new_pos
    picker.layout_config.flex[picker.__flex_strategy].prompt_position = new_pos
    picker:full_layout_update()
  elseif layout_strats._configurations[picker.layout_strategy].prompt_position then
    if picker.layout_config.prompt_position == "top" then
      picker.layout_config.prompt_position = "bottom"
      picker.layout_config[picker.layout_strategy].prompt_position = "bottom"
    else
      picker.layout_config.prompt_position = "top"
      picker.layout_config[picker.layout_strategy].prompt_position = "top"
    end
    picker:full_layout_update()
  end
end

--- Toggles the `mirror` option between `true` and `false`.
--- Checks if `mirror` is an option for the current layout.
---
--- This action is not mapped by default.
---@param prompt_bufnr number: The prompt bufnr
action_layout.toggle_mirror = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  -- flex layout is weird and needs handling separately
  if picker.layout_strategy == "flex" then
    picker.layout_config.flex.horizontal = picker.layout_config.flex.horizontal or {}
    picker.layout_config.flex.vertical = picker.layout_config.flex.vertical or {}
    local new_mirror = not picker.layout_config.flex[picker.__flex_strategy].mirror
    picker.layout_config[picker.__flex_strategy].mirror = new_mirror
    picker.layout_config.flex[picker.__flex_strategy].mirror = new_mirror
    picker:full_layout_update()
  elseif layout_strats._configurations[picker.layout_strategy].mirror then
    picker.layout_config = picker.layout_config or {}
    local new_mirror = not picker.layout_config.mirror
    picker.layout_config.mirror = new_mirror
    picker.layout_config[picker.layout_strategy] = picker.layout_config[picker.layout_strategy] or {}
    picker.layout_config[picker.layout_strategy].mirror = new_mirror
    picker:full_layout_update()
  end
end

-- Helper function for `cycle_layout_next` and `cycle_layout_prev`.
local get_cycle_layout = function(dir)
  return function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    if picker.__layout_index then
      picker.__layout_index = ((picker.__layout_index + dir - 1) % #picker.__cycle_layout_list) + 1
    else
      picker.__layout_index = 1
    end
    local new_layout = picker.__cycle_layout_list[picker.__layout_index]
    if type(new_layout) == "string" then
      picker.layout_strategy = new_layout
      picker.layout_config = {}
      picker.previewer = picker.all_previewers and picker.all_previewers[1] or nil
    elseif type(new_layout) == "table" then
      picker.layout_strategy = new_layout.layout_strategy
      picker.layout_config = new_layout.layout_config or {}
      picker.previewer = (new_layout.previewer == nil and picker.all_previewers[picker.current_previewer_index])
        or new_layout.previewer
    else
      error("Not a valid layout setup: " .. vim.inspect(new_layout) .. "\nShould be a string or a table")
    end

    picker:full_layout_update()
  end
end

--- Cycles to the next layout in `cycle_layout_list`.
---
--- This action is not mapped by default.
---@param prompt_bufnr number: The prompt bufnr
action_layout.cycle_layout_next = get_cycle_layout(1)

--- Cycles to the previous layout in `cycle_layout_list`.
---
--- This action is not mapped by default.
---@param prompt_bufnr number: The prompt bufnr
action_layout.cycle_layout_prev = get_cycle_layout(-1)

action_layout = transform_mod(action_layout)
return action_layout

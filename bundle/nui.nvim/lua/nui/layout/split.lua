local utils = require("nui.utils")
local split_utils = require("nui.split.utils")

local u = {
  is_type = utils.is_type,
  split = split_utils,
  set_win_options = utils._.set_win_options,
}

local mod = {}

---@param box_dir '"row"'|'"col"'
---@return nui_split_internal_position position
local function get_child_position(box_dir)
  if box_dir == "row" then
    return "right"
  elseif box_dir == "col" then
    return "bottom"
  end
end

---@param position nui_split_internal_position
---@param child { size: number|string|nui_layout_option_size, grow?: boolean }
---@param container_size { width?: number, height?: number }
---@param growable_dimension_per_factor? number
local function get_child_size(position, child, container_size, growable_dimension_per_factor)
  local child_size
  if not u.is_type("table", child.size) then
    child_size = child.size --[[@as number|string]]
  elseif position == "left" or position == "right" then
    child_size = child.size.width
  else
    child_size = child.size.height
  end

  if child.grow and growable_dimension_per_factor then
    child_size = math.floor(growable_dimension_per_factor * child.grow)
  end

  return u.split.calculate_window_size(position, child_size, container_size)
end

local function get_container_size(meta)
  local size = meta.container_size
  size.width = size.width or meta.container_fallback_size.width
  size.height = size.height or meta.container_fallback_size.height
  return size
end

function mod.process(box, meta)
  if box.mount or box.component or not box.box then
    return error("invalid paramter: box")
  end

  local container_size = get_container_size(meta)

  if not u.is_type("number", container_size.width) and not u.is_type("number", container_size.height) then
    return error("invalid value: box.size")
  end

  local consumed_size = {
    width = 0,
    height = 0,
  }

  local growable_child_factor = 0

  for i, child in ipairs(box.box) do
    if meta.process_growable_child or not child.grow then
      local position = get_child_position(box.dir)
      local relative = { type = "win" }
      local size = get_child_size(position, child, container_size, meta.growable_dimension_per_factor)

      consumed_size.width = consumed_size.width + (size.width or 0)
      consumed_size.height = consumed_size.height + (size.height or 0)

      if i == 1 then
        position = meta.position
        if meta.relative then
          relative = meta.relative
        end
        if position == "left" or position == "right" then
          size.width = container_size.width
        else
          size.height = container_size.height
        end
      end

      if child.component then
        child.component:update_layout({
          position = position,
          relative = relative,
          size = size,
        })
        if i == 1 and child.component.winid then
          if position == "left" or position == "right" then
            vim.api.nvim_win_set_height(child.component.winid, size.height)
          else
            vim.api.nvim_win_set_width(child.component.winid, size.width)
          end
        end
      else
        mod.process(child, {
          container_size = size,
          container_fallback_size = container_size,
          position = position,
        })
      end
    end

    if child.grow then
      growable_child_factor = growable_child_factor + child.grow
    end
  end

  if meta.process_growable_child or growable_child_factor == 0 then
    return
  end

  local growable_width = container_size.width - consumed_size.width
  local growable_height = container_size.height - consumed_size.height
  local growable_dimension = box.dir == "col" and growable_height or growable_width
  local growable_dimension_per_factor = growable_dimension / growable_child_factor

  mod.process(box, {
    container_size = meta.container_size,
    container_fallback_size = meta.container_fallback_size,
    position = meta.position,
    process_growable_child = true,
    growable_dimension_per_factor = growable_dimension_per_factor,
  })
end

---@param box table Layout.Box
local function get_first_component(box)
  if not box.box[1] then
    return
  end

  if box.box[1].component then
    return box.box[1].component
  end

  return get_first_component(box.box[1])
end

---@param box table Layout.Box
local function unset_win_options_fixsize(box)
  for _, child in ipairs(box.box) do
    if child.component then
      local winfix = child.component._._layout_orig_winfixsize
      if winfix then
        child.component._.win_options.winfixwidth = winfix.winfixwidth
        child.component._.win_options.winfixheight = winfix.winfixheight
        child.component._._layout_orig_winfixsize = nil
      end
      u.set_win_options(child.component.winid, {
        winfixwidth = child.component._.win_options.winfixwidth,
        winfixheight = child.component._.win_options.winfixheight,
      })
    else
      unset_win_options_fixsize(child)
    end
  end
end

---@param box table Layout.Box
---@param action '"mount"'|'"show"'
---@param meta? { initial_pass?: boolean }
local function do_action(box, action, meta)
  meta = meta or { root = true }

  for i, child in ipairs(box.box) do
    if not meta.initial_pass or i == 1 then
      if child.component then
        child.component._._layout_orig_winfixsize = {
          winfixwidth = child.component._.win_options.winfixwidth,
          winfixheight = child.component._.win_options.winfixheight,
        }

        child.component._.win_options.winfixwidth = i ~= 1
        child.component._.win_options.winfixheight = i == 1
        if box.dir == "col" then
          child.component._.win_options.winfixwidth = not child.component._.win_options.winfixwidth
          child.component._.win_options.winfixheight = not child.component._.win_options.winfixheight
        end

        if child.component and not child.component.winid then
          child.component._.relative.win = vim.api.nvim_get_current_win()
          child.component._.win_config.win = child.component._.relative.win
        end

        child.component[action](child.component)

        if action == "show" and not child.component._.mounted then
          child.component:mount()
        end
      else
        do_action(child, action, {
          initial_pass = true,
        })
      end
    end
  end

  if not meta.initial_pass then
    for _, child in ipairs(box.box) do
      if child.box then
        local first_component = get_first_component(child)
        if first_component and first_component.winid then
          vim.api.nvim_set_current_win(first_component.winid)
        end

        do_action(child, action, {
          initial_pass = false,
        })
      end
    end
  end

  if meta.root then
    unset_win_options_fixsize(box)
  end
end

---@param box table Layout.Box
---@param meta? { initial_pass?: boolean }
function mod.mount_box(box, meta)
  do_action(box, "mount", meta)
end

---@param box table Layout.Box
---@param meta? { initial_pass?: boolean }
function mod.show_box(box, meta)
  do_action(box, "show", meta)
end

---@param box table Layout.Box
function mod.unmount_box(box)
  for _, child in ipairs(box.box) do
    if child.component then
      child.component:unmount()
    else
      mod.unmount_box(child)
    end
  end
end

---@param box table Layout.Box
function mod.hide_box(box)
  for _, child in ipairs(box.box) do
    if child.component then
      child.component:hide()
    else
      mod.hide_box(child)
    end
  end
end

return mod

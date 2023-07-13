local utils = require("nui.utils")
local layout_utils = require("nui.layout.utils")

local u = {
  is_type = utils.is_type,
  calculate_window_size = layout_utils.calculate_window_size,
}

local mod = {}

local function get_child_position(box, child, current_position, canvas_position)
  local position = box.dir == "row" and {
    row = canvas_position.row,
    col = current_position.col,
  } or {
    col = canvas_position.col,
    row = current_position.row,
  }

  if child.component then
    local border = child.component.border
    if border and border._.type == "complex" then
      position.col = position.col + math.floor(border._.size_delta.width / 2 + 0.5)
      position.row = position.row + math.floor(border._.size_delta.height / 2 + 0.5)
    end
  end

  return position
end

---@param parent table Layout.Box
---@param child table Layout.Box
---@param container_size table
---@param growable_dimension_per_factor? number
local function get_child_size(parent, child, container_size, growable_dimension_per_factor)
  local child_size = {
    width = child.size.width,
    height = child.size.height,
  }

  if child.grow and growable_dimension_per_factor then
    if parent.dir == "col" then
      child_size.height = math.floor(growable_dimension_per_factor * child.grow)
    else
      child_size.width = math.floor(growable_dimension_per_factor * child.grow)
    end
  end

  local outer_size = u.calculate_window_size(child_size, container_size)

  local inner_size = {
    width = outer_size.width,
    height = outer_size.height,
  }

  if child.component then
    if child.component.border then
      inner_size.width = inner_size.width - child.component.border._.size_delta.width
      inner_size.height = inner_size.height - child.component.border._.size_delta.height
    end
  end

  return outer_size, inner_size
end

function mod.process(box, meta)
  if box.mount or box.component or not box.box then
    return error("invalid paramter: box")
  end

  local container_size = meta.container_size
  if not u.is_type("number", container_size.width) or not u.is_type("number", container_size.height) then
    return error("invalid value: box.size")
  end

  local current_position = {
    col = 0,
    row = 0,
  }

  local growable_child_factor = 0

  for _, child in ipairs(box.box) do
    if meta.process_growable_child or not child.grow then
      local position = get_child_position(box, child, current_position, meta.position)
      local outer_size, inner_size = get_child_size(box, child, container_size, meta.growable_dimension_per_factor)

      if child.component then
        child.component:set_layout({
          size = inner_size,
          relative = {
            type = "win",
            winid = meta.winid,
          },
          position = position,
        })
      else
        mod.process(child, {
          winid = meta.winid,
          container_size = outer_size,
          position = position,
        })
      end

      current_position.col = current_position.col + outer_size.width
      current_position.row = current_position.row + outer_size.height
    end

    if child.grow then
      growable_child_factor = growable_child_factor + child.grow
    end
  end

  if meta.process_growable_child or growable_child_factor == 0 then
    return
  end

  local growable_width = container_size.width - current_position.col
  local growable_height = container_size.height - current_position.row
  local growable_dimension = box.dir == "col" and growable_height or growable_width
  local growable_dimension_per_factor = growable_dimension / growable_child_factor

  mod.process(box, {
    winid = meta.winid,
    container_size = meta.container_size,
    position = meta.position,
    process_growable_child = true,
    growable_dimension_per_factor = growable_dimension_per_factor,
  })
end

function mod.mount_box(box)
  for _, child in ipairs(box.box) do
    if child.component then
      child.component:mount()
    else
      mod.mount_box(child)
    end
  end
end

---@param box table Layout.Box
function mod.show_box(box)
  for _, child in ipairs(box.box) do
    if child.component then
      child.component:show()
    else
      mod.show_box(child)
    end
  end
end

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

---@param box table Layout.Box
---@return table<string, table>
local function collect_box_components(box, components)
  if not components then
    components = {}
  end

  for _, child in ipairs(box.box) do
    if child.component then
      components[child.component._.id] = child.component
    else
      collect_box_components(child, components)
    end
  end

  return components
end

---@param curr_box table Layout.Box
---@param prev_box table Layout.Box
function mod.process_box_change(curr_box, prev_box)
  if curr_box == prev_box then
    return
  end

  local curr_components = collect_box_components(curr_box)
  local prev_components = collect_box_components(prev_box)

  for id, component in pairs(curr_components) do
    if not prev_components[id] then
      if not component.winid then
        if component._.mounted then
          component:show()
        else
          component:mount()
        end
      end
    end
  end

  for id, component in pairs(prev_components) do
    if not curr_components[id] then
      if component._.mounted then
        if component.winid then
          component:hide()
        end
      end
    end
  end
end

return mod

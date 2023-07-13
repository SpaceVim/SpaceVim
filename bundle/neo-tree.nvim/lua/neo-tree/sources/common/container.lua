local utils = require("neo-tree.utils")
local renderer = require("neo-tree.ui.renderer")
local highlights = require("neo-tree.ui.highlights")
local log = require("neo-tree.log")

local M = {}

local calc_rendered_width = function(rendered_item)
  local width = 0

  for _, item in ipairs(rendered_item) do
    if item.text then
      width = width + vim.fn.strchars(item.text)
    end
  end

  return width
end

local calc_container_width = function(config, node, state, context)
  local container_width = 0
  if type(config.width) == "string" then
    if config.width == "fit_content" then
      container_width = context.max_width
    elseif config.width == "100%" then
      container_width = context.available_width
    elseif config.width:match("^%d+%%$") then
      local percent = tonumber(config.width:sub(1, -2)) / 100
      container_width = math.floor(percent * context.available_width)
    else
      error("Invalid container width: " .. config.width)
    end
  elseif type(config.width) == "number" then
    container_width = config.width
  elseif type(config.width) == "function" then
    container_width = config.width(node, state)
  else
    error("Invalid container width: " .. config.width)
  end

  if config.min_width then
    container_width = math.max(container_width, config.min_width)
  end
  if config.max_width then
    container_width = math.min(container_width, config.max_width)
  end
  context.container_width = container_width
  return container_width
end

local render_content = function(config, node, state, context)
  local add_padding = function(rendered_item, should_pad)
    for _, data in ipairs(rendered_item) do
      if data.text then
        local padding = (should_pad and #data.text and data.text:sub(1, 1) ~= " ") and " " or ""
        data.text = padding .. data.text
        should_pad = data.text:sub(#data.text) ~= " "
      end
    end
    return should_pad
  end

  local max_width = 0
  local grouped_by_zindex = utils.group_by(config.content, "zindex")

  for zindex, items in pairs(grouped_by_zindex) do
    local should_pad = { left = false, right = false }
    local zindex_rendered = { left = {}, right = {} }
    local rendered_width = 0

    for _, item in ipairs(items) do
      local rendered_item = renderer.render_component(item, node, state, context.available_width)
      if rendered_item then
        local align = item.align or "left"
        should_pad[align] = add_padding(rendered_item, should_pad[align])

        vim.list_extend(zindex_rendered[align], rendered_item)
        rendered_width = rendered_width + calc_rendered_width(rendered_item)
      end
    end

    max_width = math.max(max_width, rendered_width)
    grouped_by_zindex[zindex] = zindex_rendered
  end

  context.max_width = max_width
  context.grouped_by_zindex = grouped_by_zindex
  return context
end

---Takes a list of rendered components and truncates them to fit the container width
---@param layer table The list of rendered components.
---@param skip_count number The number of characters to skip from the begining/left.
---@param max_length number The maximum number of characters to return.
local truncate_layer_keep_left = function(layer, skip_count, max_length)
  local result = {}
  local taken = 0
  local skipped = 0
  for _, item in ipairs(layer) do
    local remaining_to_skip = skip_count - skipped
    if remaining_to_skip > 0 then
      if #item.text <= remaining_to_skip then
        skipped = skipped + vim.fn.strchars(item.text)
        item.text = ""
      else
        item.text = item.text:sub(remaining_to_skip)
        if #item.text + taken > max_length then
          item.text = item.text:sub(1, max_length - taken)
        end
        table.insert(result, item)
        taken = taken + #item.text
        skipped = skipped + remaining_to_skip
      end
    elseif taken <= max_length then
      if #item.text + taken > max_length then
        item.text = item.text:sub(1, max_length - taken)
      end
      table.insert(result, item)
      taken = taken + vim.fn.strchars(item.text)
    end
  end
  return result
end

---Takes a list of rendered components and truncates them to fit the container width
---@param layer table The list of rendered components.
---@param skip_count number The number of characters to skip from the end/right.
---@param max_length number The maximum number of characters to return.
local truncate_layer_keep_right = function(layer, skip_count, max_length)
  local result = {}
  local taken = 0
  local skipped = 0
  local i = #layer
  while i > 0 do
    local item = layer[i]
    i = i - 1
    local text_length = vim.fn.strchars(item.text)
    local remaining_to_skip = skip_count - skipped
    if remaining_to_skip > 0 then
      if text_length <= remaining_to_skip then
        skipped = skipped + text_length
        item.text = ""
      else
        item.text = vim.fn.strcharpart(item.text, 0, text_length - remaining_to_skip)
        text_length = vim.fn.strchars(item.text)
        if text_length + taken > max_length then
          item.text = vim.fn.strcharpart(item.text, text_length - (max_length - taken))
          text_length = vim.fn.strchars(item.text)
        end
        table.insert(result, item)
        taken = taken + text_length
        skipped = skipped + remaining_to_skip
      end
    elseif taken <= max_length then
      if text_length + taken > max_length then
        item.text = vim.fn.strcharpart(item.text, text_length - (max_length - taken))
        text_length = vim.fn.strchars(item.text)
      end
      table.insert(result, item)
      taken = taken + text_length
    end
  end
  return result
end

local fade_content = function(layer, fade_char_count)
  local text = layer[#layer].text
  if not text or #text == 0 then
    return
  end
  local hl = layer[#layer].highlight or "Normal"
  local fade = {
    highlights.get_faded_highlight_group(hl, 0.68),
    highlights.get_faded_highlight_group(hl, 0.6),
    highlights.get_faded_highlight_group(hl, 0.35),
  }

  for i = 3, 1, -1 do
    if #text >= i and fade_char_count >= i then
      layer[#layer].text = text:sub(1, -i - 1)
      for j = i, 1, -1 do
        -- force no padding for each faded character
        local entry = { text = text:sub(-j, -j), highlight = fade[i - j + 1], no_padding = true }
        table.insert(layer, entry)
      end
      break
    end
  end
end

local try_fade_content = function(layer, fade_char_count)
  local success, err = pcall(fade_content, layer, fade_char_count)
  if not success then
    log.debug("Error while trying to fade content: ", err)
  end
end

local merge_content = function(context)
  -- Heres the idea:
  -- * Starting backwards from the layer with the highest zindex
  --   set the left and right tables to the content of the layer
  -- * If a layer has more content than will fit, the left side will be truncated.
  -- * If the available space is not used up, move on to the next layer
  -- * With each subsequent layer, if the length of that layer is greater then the existing
  --   length for that side (left or right), then clip that layer and append whatver portion is
  --   not covered up to the appropriate side.
  -- * Check again to see if we have used up the available width, short circuit if we have.
  -- * Repeat until all layers have been merged.
  -- * Join the left and right tables together and return.
  --
  local remaining_width = context.container_width
  local left, right = {}, {}
  local left_width, right_width = 0, 0
  local wanted_width = 0

  if context.left_padding and context.left_padding > 0 then
    table.insert(left, { text = string.rep(" ", context.left_padding) })
    remaining_width = remaining_width - context.left_padding
    left_width = left_width + context.left_padding
    wanted_width = wanted_width + context.left_padding
  end

  if context.right_padding and context.right_padding > 0 then
    remaining_width = remaining_width - context.right_padding
    wanted_width = wanted_width + context.right_padding
  end

  local keys = utils.get_keys(context.grouped_by_zindex, true)
  if type(keys) ~= "table" then
    return {}
  end
  local i = #keys
  while i > 0 do
    local key = keys[i]
    local layer = context.grouped_by_zindex[key]
    i = i - 1

    if utils.truthy(layer.right) then
      local width = calc_rendered_width(layer.right)
      wanted_width = wanted_width + width
      if remaining_width > 0 then
        context.has_right_content = true
        if width > remaining_width then
          local truncated = truncate_layer_keep_right(layer.right, right_width, remaining_width)
          vim.list_extend(right, truncated)
          remaining_width = 0
        else
          remaining_width = remaining_width - width
          vim.list_extend(right, layer.right)
          right_width = right_width + width
        end
      end
    end

    if utils.truthy(layer.left) then
      local width = calc_rendered_width(layer.left)
      wanted_width = wanted_width + width
      if remaining_width > 0 then
        if width > remaining_width then
          local truncated = truncate_layer_keep_left(layer.left, left_width, remaining_width)
          if context.enable_character_fade then
            try_fade_content(truncated, 3)
          end
          vim.list_extend(left, truncated)
          remaining_width = 0
        else
          remaining_width = remaining_width - width
          if context.enable_character_fade and not context.auto_expand_width then
            local fade_chars = 3 - remaining_width
            if fade_chars > 0 then
              try_fade_content(layer.left, fade_chars)
            end
          end
          vim.list_extend(left, layer.left)
          left_width = left_width + width
        end
      end
    end

    if remaining_width == 0 and not context.auto_expand_width then
      i = 0
      break
    end
  end

  if remaining_width > 0 and #right > 0 then
    table.insert(left, { text = string.rep(" ", remaining_width) })
  end

  local result = {}
  vim.list_extend(result, left)

  -- we do not pad between left and right side
  if #right >= 1 then
    right[1].no_padding = true
  end

  vim.list_extend(result, right)
  context.merged_content = result
  log.trace("wanted width: ", wanted_width, " actual width: ", context.container_width)
  context.wanted_width = math.max(wanted_width, context.wanted_width)
end

M.render = function(config, node, state, available_width)
  local context = {
    wanted_width = 0,
    max_width = 0,
    grouped_by_zindex = {},
    available_width = available_width,
    left_padding = config.left_padding,
    right_padding = config.right_padding,
    enable_character_fade = config.enable_character_fade,
    auto_expand_width = state.window.auto_expand_width and state.window.position ~= "float",
  }

  render_content(config, node, state, context)
  calc_container_width(config, node, state, context)
  merge_content(context)

  if context.has_right_content then
    state.has_right_content = true
  end

  -- we still want padding between this container and the previous component
  if #context.merged_content > 0 then
    context.merged_content[1].no_padding = false
  end
  return context.merged_content, context.wanted_width
end

return M

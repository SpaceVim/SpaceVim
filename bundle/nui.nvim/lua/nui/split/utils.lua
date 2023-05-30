local utils = require("nui.utils")
local layout_utils = require("nui.layout.utils")

local u = {
  defaults = utils.defaults,
  get_editor_size = utils.get_editor_size,
  get_window_size = utils.get_window_size,
  is_type = utils.is_type,
  normalize_dimension = utils._.normalize_dimension,
  size = layout_utils.size,
}

local mod = {}

---@param size number|string|nui_layout_option_size
---@param position nui_split_internal_position
---@return number|string size
local function to_split_size(size, position)
  if not u.is_type("table", size) then
    ---@cast size number|string
    return size
  end

  if position == "left" or position == "right" then
    return size.width
  end

  return size.height
end

---@param options table
---@return table options
function mod.merge_default_options(options)
  options.relative = u.defaults(options.relative, "win")
  options.position = u.defaults(options.position, vim.go.splitbelow and "bottom" or "top")

  options.enter = u.defaults(options.enter, true)

  options.buf_options = u.defaults(options.buf_options, {})
  options.win_options = vim.tbl_extend("force", {
    winfixwidth = true,
    winfixheight = true,
  }, u.defaults(options.win_options, {}))

  return options
end

---@param options table
---@return table options
function mod.normalize_layout_options(options)
  if utils.is_type("string", options.relative) then
    options.relative = {
      type = options.relative,
    }
  end

  return options
end

---@param options table
---@return table options
function mod.normalize_options(options)
  options = mod.normalize_layout_options(options)

  return options
end

local function parse_relative(relative, fallback_winid)
  local winid = u.defaults(relative.winid, fallback_winid)

  return {
    type = relative.type,
    win = winid,
  }
end

---@param relative nui_split_internal_relative
local function get_container_info(relative)
  if relative.type == "editor" then
    local size = u.get_editor_size()

    -- best effort adjustments
    size.height = size.height - vim.api.nvim_get_option("cmdheight")
    if vim.api.nvim_get_option("laststatus") >= 2 then
      size.height = size.height - 1
    end
    if vim.api.nvim_get_option("showtabline") == 2 then
      size.height = size.height - 1
    end

    return {
      size = size,
      type = "editor",
    }
  end

  if relative.type == "win" then
    return {
      size = u.get_window_size(relative.win),
      type = "window",
    }
  end
end

---@param position nui_split_internal_position
---@param size number|string
---@param container_size { width: number, height: number }
---@return { width?: number, height?: number }
function mod.calculate_window_size(position, size, container_size)
  if not size then
    return {}
  end

  if position == "left" or position == "right" then
    return {
      width = u.normalize_dimension(size, container_size.width),
    }
  end

  return {
    height = u.normalize_dimension(size, container_size.height),
  }
end

function mod.update_layout_config(component_internal, config)
  local internal = component_internal

  local options = mod.normalize_layout_options({
    relative = config.relative,
    position = config.position,
    size = config.size,
  })

  if internal.relative and internal.relative.win and not vim.api.nvim_win_is_valid(internal.relative.win) then
    internal.relative.win = vim.api.nvim_get_current_win()

    internal.win_config.win = internal.relative.win

    internal.win_config.pending_changes.relative = true
  end

  if options.relative then
    local fallback_winid = internal.relative and internal.relative.win or vim.api.nvim_get_current_win()
    internal.relative = parse_relative(options.relative, fallback_winid)

    local prev_relative = internal.win_config.relative
    local prev_win = internal.win_config.win

    internal.win_config.relative = internal.relative.type
    internal.win_config.win = internal.relative.type == "win" and internal.relative.win or nil

    internal.win_config.pending_changes.relative = internal.win_config.relative ~= prev_relative
      or internal.win_config.win ~= prev_win
  end

  if options.position or internal.win_config.pending_changes.relative then
    local prev_position = internal.win_config.position

    internal.position = options.position or internal.position

    internal.win_config.position = internal.position

    internal.win_config.pending_changes.position = internal.win_config.position ~= prev_position
  end

  if options.size or internal.win_config.pending_changes.position or internal.win_config.pending_changes.relative then
    internal.layout.size = to_split_size(options.size or internal.layout.size, internal.position)

    internal.container_info = get_container_info(internal.relative)
    internal.size = mod.calculate_window_size(internal.position, internal.layout.size, internal.container_info.size)

    internal.win_config.width = internal.size.width
    internal.win_config.height = internal.size.height

    internal.win_config.pending_changes.size = true
  end
end

return mod

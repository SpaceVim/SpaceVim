local Object = require("nui.object")
local Line = require("nui.line")
local Text = require("nui.text")
local _ = require("nui.utils")._
local defaults = require("nui.utils").defaults
local is_type = require("nui.utils").is_type

local u = {
  clear_namespace = _.clear_namespace,
}

local has_nvim_0_5_1 = vim.fn.has("nvim-0.5.1") == 1

local index_name = {
  "top_left",
  "top",
  "top_right",
  "right",
  "bottom_right",
  "bottom",
  "bottom_left",
  "left",
}

local function to_border_map(border)
  -- fillup all 8 characters
  local count = vim.tbl_count(border)
  if count < 8 then
    for i = count + 1, 8 do
      local fallback_index = i % count
      local char = border[fallback_index == 0 and count or fallback_index]
      if is_type("table", char) then
        char = char.content and Text(char) or vim.deepcopy(char)
      end
      border[i] = char
    end
  end

  local named_border = {}

  for index, name in ipairs(index_name) do
    named_border[name] = border[index]
  end

  return named_border
end

local function to_border_list(named_border)
  local border = {}

  for index, name in ipairs(index_name) do
    if is_type("nil", named_border[name]) then
      error(string.format("missing named border: %s", name))
    end

    border[index] = named_border[name]
  end

  return border
end

---@param internal nui_popup_border_internal
local function normalize_border_char(internal)
  if not internal.char or is_type("string", internal.char) then
    return internal.char
  end

  if internal.type == "simple" then
    for position, item in pairs(internal.char) do
      if is_type("string", item) then
        internal.char[position] = item
      elseif item.content then
        if item.extmark and item.extmark.hl_group then
          internal.char[position] = { item:content(), item.extmark.hl_group }
        else
          internal.char[position] = item:content()
        end
      else
        internal.char[position] = item
      end
    end

    return internal.char
  end

  for position, item in pairs(internal.char) do
    if is_type("string", item) then
      internal.char[position] = Text(item, "FloatBorder")
    elseif not item.content then
      internal.char[position] = Text(item[1], item[2] or "FloatBorder")
    elseif item.extmark then
      item.extmark.hl_group = item.extmark.hl_group or "FloatBorder"
    else
      item.extmark = { hl_group = "FloatBorder" }
    end
  end

  return internal.char
end

---@param text? nil | string | NuiText
local function normalize_border_text(text)
  if not text then
    return text
  end

  if is_type("string", text) then
    return Text(text, "FloatTitle")
  end

  text.extmark = vim.tbl_deep_extend("keep", text.extmark or {}, {
    hl_group = "FloatTitle",
  })

  return text
end

---@param internal nui_popup_border_internal
---@param popup_winhighlight? string
local function calculate_winhighlight(internal, popup_winhighlight)
  if internal.type == "simple" then
    return
  end

  local winhl = popup_winhighlight

  -- @deprecated
  if internal.highlight then
    if not string.match(internal.highlight, ":") then
      internal.highlight = "FloatBorder:" .. internal.highlight
    end

    winhl = internal.highlight
    internal.highlight = nil
  end

  return winhl
end

---@return nui_popup_border_internal_padding|nil
local function parse_padding(padding)
  if not padding then
    return nil
  end

  if is_type("map", padding) then
    return padding
  end

  local map = {}
  map.top = defaults(padding[1], 0)
  map.right = defaults(padding[2], map.top)
  map.bottom = defaults(padding[3], map.top)
  map.left = defaults(padding[4], map.right)
  return map
end

---@param edge "'top'" | "'bottom'"
---@param text? nil | string | NuiText
---@param align? nil | "'left'" | "'center'" | "'right'"
---@return table NuiLine
local function calculate_buf_edge_line(internal, edge, text, align)
  local char, size = internal.char, internal.size

  local left_char = char[edge .. "_left"]
  local mid_char = char[edge]
  local right_char = char[edge .. "_right"]

  if left_char:content() == "" then
    left_char = Text(mid_char:content() == "" and char["left"] or mid_char)
  end

  if right_char:content() == "" then
    right_char = Text(mid_char:content() == "" and char["right"] or mid_char)
  end

  local max_width = size.width - left_char:width() - right_char:width()

  local content_text = Text(defaults(text, ""))
  if mid_char:width() == 0 then
    content_text:set(string.rep(" ", max_width))
  else
    content_text:set(_.truncate_text(content_text:content(), max_width))
  end

  local left_gap_width, right_gap_width = _.calculate_gap_width(
    defaults(align, "center"),
    max_width,
    content_text:width()
  )

  local line = Line()

  line:append(left_char)

  if left_gap_width > 0 then
    line:append(Text(mid_char):set(string.rep(mid_char:content(), left_gap_width)))
  end

  line:append(content_text)

  if right_gap_width > 0 then
    line:append(Text(mid_char):set(string.rep(mid_char:content(), right_gap_width)))
  end

  line:append(right_char)

  return line
end

---@return nil | table[] # NuiLine[]
local function calculate_buf_lines(internal)
  local char, size, text = internal.char, internal.size, defaults(internal.text, {})

  if is_type("string", char) then
    return nil
  end

  local left_char, right_char = char.left, char.right

  local gap_length = size.width - left_char:width() - right_char:width()

  local lines = {}

  table.insert(lines, calculate_buf_edge_line(internal, "top", text.top, text.top_align))
  for _ = 1, size.height - 2 do
    table.insert(
      lines,
      Line({
        Text(left_char),
        Text(string.rep(" ", gap_length)),
        Text(right_char),
      })
    )
  end
  table.insert(lines, calculate_buf_edge_line(internal, "bottom", text.bottom, text.bottom_align))

  return lines
end

local styles = {
  double = to_border_map({ "╔", "═", "╗", "║", "╝", "═", "╚", "║" }),
  none = "none",
  rounded = to_border_map({ "╭", "─", "╮", "│", "╯", "─", "╰", "│" }),
  shadow = "shadow",
  single = to_border_map({ "┌", "─", "┐", "│", "┘", "─", "└", "│" }),
  solid = to_border_map({ "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" }),
}

---@param internal nui_popup_border_internal
---@return nui_popup_border_internal_size
local function calculate_size_delta(internal)
  ---@type nui_popup_border_internal_size
  local delta = {
    width = 0,
    height = 0,
  }

  local char = internal.char
  if is_type("map", char) then
    if char.top ~= "" then
      delta.height = delta.height + 1
    end

    if char.bottom ~= "" then
      delta.height = delta.height + 1
    end

    if char.left ~= "" then
      delta.width = delta.width + 1
    end

    if char.right ~= "" then
      delta.width = delta.width + 1
    end
  end

  local padding = internal.padding
  if padding then
    if padding.top then
      delta.height = delta.height + padding.top
    end

    if padding.bottom then
      delta.height = delta.height + padding.bottom
    end

    if padding.left then
      delta.width = delta.width + padding.left
    end

    if padding.right then
      delta.width = delta.width + padding.right
    end
  end

  return delta
end

---@param border NuiPopupBorder
---@return nui_popup_border_internal_size
local function calculate_size(border)
  ---@type nui_popup_border_internal_size
  local size = vim.deepcopy(border.popup._.size)

  size.width = size.width + border._.size_delta.width
  size.height = size.height + border._.size_delta.height

  return size
end

---@param border NuiPopupBorder
---@return nui_popup_border_internal_position
local function calculate_position(border)
  local position = vim.deepcopy(border.popup._.position)
  position.col = position.col - math.floor(border._.size_delta.width / 2 + 0.5)
  position.row = position.row - math.floor(border._.size_delta.height / 2 + 0.5)
  return position
end

local function adjust_popup_win_config(border)
  local internal = border._

  if internal.type ~= "complex" then
    return
  end

  local popup_position = {
    row = 0,
    col = 0,
  }

  local char = internal.char

  if is_type("map", char) then
    if char.top ~= "" then
      popup_position.row = popup_position.row + 1
    end

    if char.left ~= "" then
      popup_position.col = popup_position.col + 1
    end
  end

  local padding = internal.padding

  if padding then
    if padding.top then
      popup_position.row = popup_position.row + padding.top
    end

    if padding.left then
      popup_position.col = popup_position.col + padding.left
    end
  end

  local popup = border.popup

  if not has_nvim_0_5_1 then
    popup.win_config.row = internal.position.row + popup_position.row
    popup.win_config.col = internal.position.col + popup_position.col
    return
  end

  popup.win_config.relative = "win"
  -- anchor to the border window instead
  popup.win_config.anchor = "NW"
  popup.win_config.win = border.winid
  popup.win_config.bufpos = nil
  popup.win_config.row = popup_position.row
  popup.win_config.col = popup_position.col
end

--luacheck: push no max line length

---@alias nui_t_text_align "'left'" | "'center'" | "'right'"
---@alias nui_popup_border_internal_padding { top: number, right: number, bottom: number, left: number }
---@alias nui_popup_border_internal_position { row: number, col: number }
---@alias nui_popup_border_internal_size { width: number, height: number }
---@alias nui_popup_border_internal_text { top?: string|NuiText, top_align?: nui_t_text_align, bottom?: string|NuiText, bottom_align?: nui_t_text_align }
---@alias nui_popup_border_internal { type: "'simple'"|"'complex'", style: table, char: any, padding?: nui_popup_border_internal_padding, position: nui_popup_border_internal_position, size: nui_popup_border_internal_size, size_delta: nui_popup_border_internal_size, text: nui_popup_border_internal_text, lines?: table[], winhighlight?: string }

--luacheck: pop

---@class NuiPopupBorder
---@field bufnr integer
---@field private _ nui_popup_border_internal
---@field private popup NuiPopup
---@field win_config nui_popup_win_config
---@field winid number
local Border = Object("NuiPopupBorder")

---@param popup NuiPopup
function Border:init(popup, options)
  self.popup = popup

  self._ = {
    type = "simple",
    style = defaults(options.style, "none"),
    -- @deprecated
    highlight = options.highlight,
    padding = parse_padding(options.padding),
    text = options.text,
  }

  local internal = self._

  if internal.text then
    internal.text.top = normalize_border_text(internal.text.top)
    internal.text.bottom = normalize_border_text(internal.text.bottom)
  end

  local style = internal.style

  if is_type("list", style) then
    internal.char = to_border_map(style)
  elseif is_type("string", style) then
    if not styles[style] then
      error("invalid border style name")
    end

    internal.char = vim.deepcopy(styles[style])
  else
    internal.char = internal.style
  end

  local is_borderless = is_type("string", internal.char)

  if is_borderless then
    if internal.text then
      error("text not supported for style:" .. internal.char)
    end
  end

  if internal.text or internal.padding then
    internal.type = "complex"
  end

  internal.winhighlight = calculate_winhighlight(internal, self.popup._.win_options.winhighlight)

  internal.char = normalize_border_char(internal)

  internal.size_delta = calculate_size_delta(internal)

  if internal.type == "simple" then
    return self
  end

  self.win_config = {
    style = "minimal",
    border = "none",
    focusable = false,
    zindex = self.popup.win_config.zindex - 1,
    anchor = self.popup.win_config.anchor,
  }

  if type(internal.char) == "string" then
    self.win_config.border = internal.char
  end
end

function Border:_open_window()
  if self.winid or not self.bufnr then
    return
  end

  self.win_config.noautocmd = true
  self.winid = vim.api.nvim_open_win(self.bufnr, false, self.win_config)
  self.win_config.noautocmd = nil
  assert(self.winid, "failed to create border window")

  if self._.winhighlight then
    vim.api.nvim_win_set_option(self.winid, "winhighlight", self._.winhighlight)
  end

  adjust_popup_win_config(self)

  vim.api.nvim_command("redraw")
end

function Border:_close_window()
  if not self.winid then
    return
  end

  if vim.api.nvim_win_is_valid(self.winid) then
    vim.api.nvim_win_close(self.winid, true)
  end

  self.winid = nil
end

function Border:mount()
  local popup = self.popup

  if not popup._.loading or popup._.mounted then
    return
  end

  local internal = self._

  if internal.type == "simple" then
    return
  end

  self.bufnr = vim.api.nvim_create_buf(false, true)
  assert(self.bufnr, "failed to create border buffer")

  if internal.lines then
    _.render_lines(internal.lines, self.bufnr, popup.ns_id, 1, #internal.lines)
  end

  self:_open_window()
end

function Border:unmount()
  local popup = self.popup

  if not popup._.loading or not popup._.mounted then
    return
  end

  local internal = self._

  if internal.type == "simple" then
    return
  end

  if self.bufnr then
    if vim.api.nvim_buf_is_valid(self.bufnr) then
      u.clear_namespace(self.bufnr, self.popup.ns_id)
      vim.api.nvim_buf_delete(self.bufnr, { force = true })
    end
    self.bufnr = nil
  end

  self:_close_window()
end

function Border:_relayout()
  local internal = self._

  if internal.type ~= "complex" then
    return
  end

  local position = self.popup._.position
  self.win_config.relative = position.relative
  self.win_config.win = position.relative == "win" and position.win or nil
  self.win_config.bufpos = position.bufpos

  internal.size = calculate_size(self)
  self.win_config.width = internal.size.width
  self.win_config.height = internal.size.height

  internal.position = calculate_position(self)
  self.win_config.row = internal.position.row
  self.win_config.col = internal.position.col

  internal.lines = calculate_buf_lines(internal)

  if self.winid then
    vim.api.nvim_win_set_config(self.winid, self.win_config)
  end

  if self.bufnr then
    if internal.lines then
      _.render_lines(internal.lines, self.bufnr, self.popup.ns_id, 1, #internal.lines)
    end
  end

  adjust_popup_win_config(self)

  vim.api.nvim_command("redraw")
end

---@param edge "'top'" | "'bottom'"
---@param text? nil | string | table # string or NuiText
---@param align? nil | "'left'" | "'center'" | "'right'"
function Border:set_text(edge, text, align)
  local internal = self._

  if not internal.lines or not internal.text then
    return
  end

  internal.text[edge] = normalize_border_text(text)
  internal.text[edge .. "_align"] = defaults(align, internal.text[edge .. "_align"])

  local line = calculate_buf_edge_line(internal, edge, internal.text[edge], internal.text[edge .. "_align"])

  local linenr = edge == "top" and 1 or #internal.lines

  internal.lines[linenr] = line
  line:render(self.bufnr, self.popup.ns_id, linenr)
end

---@param highlight string highlight group
function Border:set_highlight(highlight)
  local internal = self._

  local winhighlight_data = _.parse_winhighlight(self.popup._.win_options.winhighlight)
  winhighlight_data["FloatBorder"] = highlight
  self.popup._.win_options.winhighlight = _.serialize_winhighlight(winhighlight_data)
  if self.popup.winid then
    vim.api.nvim_win_set_option(self.popup.winid, "winhighlight", self.popup._.win_options.winhighlight)
  end

  internal.winhighlight = calculate_winhighlight(internal, self.popup._.win_options.winhighlight)
  if self.winid then
    vim.api.nvim_win_set_option(self.winid, "winhighlight", internal.winhighlight)
  end
end

function Border:get()
  local internal = self._

  if internal.type ~= "simple" then
    return nil
  end

  if is_type("string", internal.char) then
    return internal.char
  end

  if is_type("map", internal.char) then
    return to_border_list(internal.char)
  end
end

---@alias NuiPopupBorder.constructor fun(popup: NuiPopup, options: table): NuiPopupBorder
---@type NuiPopupBorder|NuiPopupBorder.constructor
local NuiPopupBorder = Border

return NuiPopupBorder

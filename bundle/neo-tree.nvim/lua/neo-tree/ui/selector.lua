local vim = vim
local utils = require("neo-tree.utils")
local log = require("neo-tree.log")
local manager = require("neo-tree.sources.manager")

local M = {}

---calc_click_id_from_source:
-- Calculates click_id that stores information of the source and window id
-- DANGER: Do not change this function unless you know what you are doing
---@param winid integer: window id of the window source_selector is placed
---@param source_index integer: index of the source
---@return integer
local calc_click_id_from_source = function(winid, source_index)
  local base_number = #require("neo-tree").config.source_selector.sources + 1
  return base_number * winid + source_index
end

---calc_source_from_click_id:
-- Calculates source index and window id from click_id. Paired with `M.calc_click_id_from_source`
-- DANGER: Do not change this function unless you know what you are doing
---@param click_id integer: click_id
---@return integer, integer
local calc_source_from_click_id = function(click_id)
  local base_number = #require("neo-tree").config.source_selector.sources + 1
  return math.floor(click_id / base_number), click_id % base_number
end
---sep_tbl:
-- Returns table expression of separator.
-- Converts to table expression if sep is string.
---@param sep string | table:
---@return table: `{ left = .., right = .., override = .. }`
local sep_tbl = function(sep)
  if type(sep) == "nil" then
    return {}
  elseif type(sep) ~= "table" then
    return { left = sep, right = sep, override = "active" }
  end
  return sep
end

-- Function below provided by @akinsho
-- https://github.com/nvim-neo-tree/neo-tree.nvim/pull/427#discussion_r924947766

-- truncate a string based on number of display columns/cells it occupies
-- so that multibyte characters are not broken up mid-character
---@param str string
---@param col_limit number
---@return string
local function truncate_by_cell(str, col_limit)
  local api = vim.api
  local fn = vim.fn
  if str and str:len() == api.nvim_strwidth(str) then
    return fn.strcharpart(str, 0, col_limit)
  end
  local short = fn.strcharpart(str, 0, col_limit)
  if api.nvim_strwidth(short) > col_limit then
    while api.nvim_strwidth(short) > col_limit do
      short = fn.strcharpart(short, 0, fn.strchars(short) - 1)
    end
  end
  return short
end

---get_separators
-- Returns information about separator on each tab.
---@param source_index integer: index of source
---@param active_index integer: index of active source. used to check if source is active and when `override = "active"`
---@param force_ignore_left boolean: overwrites calculated results with "" if set to true
---@param force_ignore_right boolean: overwrites calculated results with "" if set to true
---@return table: something like `{ left = "|", right = "|" }`
local get_separators = function(source_index, active_index, force_ignore_left, force_ignore_right)
  local config = require("neo-tree").config
  local is_active = source_index == active_index
  local sep = sep_tbl(config.source_selector.separator)
  if is_active then
    sep = vim.tbl_deep_extend("force", sep, sep_tbl(config.source_selector.separator_active))
  end
  local show_left = sep.override == "left"
    or (sep.override == "active" and source_index <= active_index)
    or sep.override == nil
  local show_right = sep.override == "right"
    or (sep.override == "active" and source_index >= active_index)
    or sep.override == nil
  return {
    left = (show_left and not force_ignore_left) and sep.left or "",
    right = (show_right and not force_ignore_right) and sep.right or "",
  }
end

---get_selector_tab_info:
-- Returns information to create a tab
---@param source_name string: name of source. should be same as names in `config.sources`
---@param source_index integer: index of source_name
---@param is_active boolean: whether this source is currently focused
---@param separator table: `{ left = .., right = .. }`: output from `get_separators()`
---@return table (see code): Note: `length`: length of whole tab (including seps), `text_length`: length of tab excluding seps
local get_selector_tab_info = function(source_name, source_index, is_active, separator)
  local config = require("neo-tree").config
  local separator_config = utils.resolve_config_option(config, "source_selector", nil)
  if separator_config == nil then
    log.warn("Cannot find source_selector config. `get_selector` abort.")
    return {}
  end
  local source_config = config[source_name] or {}
  local get_strlen = vim.api.nvim_strwidth
  local text = separator_config.sources[source_index].display_name or source_config.display_name or source_name
  local text_length = get_strlen(text)
  if separator_config.tabs_min_width ~= nil and text_length < separator_config.tabs_min_width then
    text = M.text_layout(text, separator_config.content_layout, separator_config.tabs_min_width)
    text_length = separator_config.tabs_min_width
  end
  if separator_config.tabs_max_width ~= nil and text_length > separator_config.tabs_max_width then
    text = M.text_layout(text, separator_config.content_layout, separator_config.tabs_max_width)
    text_length = separator_config.tabs_max_width
  end
  local tab_hl = is_active and separator_config.highlight_tab_active
    or separator_config.highlight_tab
  local sep_hl = is_active and separator_config.highlight_separator_active
    or separator_config.highlight_separator
  return {
    index = source_index,
    is_active = is_active,
    left = separator.left,
    right = separator.right,
    text = text,
    tab_hl = tab_hl,
    sep_hl = sep_hl,
    length = text_length + get_strlen(separator.left) + get_strlen(separator.right),
    text_length = text_length,
  }
end

---text_with_hl:
-- Returns text with highlight syntax for winbar / statusline
---@param text string: text to highlight
---@param tab_hl string | nil: if nil, does nothing
---@return string: e.g. "%#HiName#text"
local text_with_hl = function(text, tab_hl)
  if tab_hl == nil then
    return text
  end
  return string.format("%%#%s#%s", tab_hl, text)
end

---add_padding:
-- Use for creating padding with highlight
---@param padding_legth number: number of padding. if float, value is rounded with `math.floor`
---@param padchar string | nil: if nil, " " (space) is used
---@return string
local add_padding = function(padding_legth, padchar)
  if padchar == nil then
    padchar = " "
  end
  return string.rep(padchar, math.floor(padding_legth))
end

---text_layout:
-- Add padding to fill `output_width`.
-- If `output_width` is less than `text_length`, text is truncated to fit `output_width`.
---@param text string:
---@param content_layout string: `"start", "center", "end"`: see `config.source_selector.tabs_layout` for more details
---@param output_width integer: exact `strdisplaywidth` of the output string
---@param trunc_char string | nil: Character used to indicate truncation. If nil, "…" (ellipsis) is used.
---@return string
local text_layout = function(text, content_layout, output_width, trunc_char)
  if output_width < 1 then
    return ""
  end
  local text_length = vim.fn.strdisplaywidth(text)
  local pad_length = output_width - text_length
  local left_pad, right_pad = 0, 0
  if pad_length < 0 then
    if output_width < 4 then
      return truncate_by_cell(text, output_width)
    else
      return truncate_by_cell(text, output_width - 1) .. trunc_char
    end
  elseif content_layout == "start" then
    left_pad, right_pad = 0, pad_length
  elseif content_layout == "end" then
    left_pad, right_pad = pad_length, 0
  elseif content_layout == "center" then
    left_pad, right_pad = pad_length / 2, math.ceil(pad_length / 2)
  end
  return add_padding(left_pad) .. text .. add_padding(right_pad)
end

---render_tab:
-- Renders string to express one tab for winbar / statusline.
---@param left_sep string: left separator
---@param right_sep string: right separator
---@param sep_hl string: highlight of separators
---@param text string: text, mostly name of source in this case
---@param tab_hl string: highlight of text
---@param click_id integer: id passed to `___neotree_selector_click`, should be calculated with `M.calc_click_id_from_source`
---@return string: complete string to render one tab
local render_tab = function(left_sep, right_sep, sep_hl, text, tab_hl, click_id)
  local res = "%" .. click_id .. "@v:lua.___neotree_selector_click@"
  if left_sep ~= nil then
    res = res .. text_with_hl(left_sep, sep_hl)
  end
  res = res .. text_with_hl(text, tab_hl)
  if right_sep ~= nil then
    res = res .. text_with_hl(right_sep, sep_hl)
  end
  return res
end

M.get_scrolled_off_node_text = function(state)
  if state == nil then
    state = require("neo-tree.sources.manager").get_state_for_window()
    if state == nil then
      return
    end
  end
  local win_top_line = vim.fn.line("w0")
  if win_top_line == nil or win_top_line == 1 then
    return
  end
  local node = state.tree:get_node(win_top_line)
  return "   " .. vim.fn.fnamemodify(node.path, ":~:h")
end

M.get = function()
  local state = require("neo-tree.sources.manager").get_state_for_window()
  if state == nil then
    return
  else
    local config = require("neo-tree").config
    local scrolled_off =
      utils.resolve_config_option(config, "source_selector.show_scrolled_off_parent_node", false)
    if scrolled_off then
      local node_text = M.get_scrolled_off_node_text(state)
      if node_text ~= nil then
        return node_text
      end
    end
    return M.get_selector(state, vim.api.nvim_win_get_width(0))
  end
end

---get_selector:
-- Does everything to generate the string for source_selector in winbar / statusline.
---@param state table:
---@param width integer: width of the entire window where the source_selector is displayed
---@return string | nil
M.get_selector = function(state, width)
  local config = require("neo-tree").config
  if config == nil then
    log.warn("Cannot find config. `get_selector` abort.")
    return nil
  end
  local winid = state.winid or vim.api.nvim_get_current_win()

  -- load padding from config
  local padding = config.source_selector.padding
  if type(padding) == "number" then
    padding = { left = padding, right = padding }
  end
  width = math.floor(width - padding.left - padding.right)

  -- generate information of each tab (look `get_selector_tab_info` for type hint)
  local tabs = {}
  local sources = config.source_selector.sources
  local active_index = #sources
  local length_sum, length_active, length_separators = 0, 0, 0
  for i, source_info in ipairs(sources) do
    local is_active = source_info.source == state.name
    if is_active then
      active_index = i
    end
    local separator = get_separators(
      i,
      active_index,
      config.source_selector.show_separator_on_edge == false and i == 1,
      config.source_selector.show_separator_on_edge == false and i == #sources
    )
    local element = get_selector_tab_info(source_info.source, i, is_active, separator)
    length_sum = length_sum + element.length
    length_separators = length_separators + element.length - element.text_length
    if is_active then
      length_active = element.length
    end
    table.insert(tabs, element)
  end

  -- start creating string to display
  local tabs_layout = config.source_selector.tabs_layout
  local content_layout = config.source_selector.content_layout or "center"
  local hl_background = config.source_selector.highlight_background
  local trunc_char = config.source_selector.truncation_character or "…"
  local remaining_width = width - length_separators
  local return_string = text_with_hl(add_padding(padding.left), hl_background)
  if width < length_sum and config.source_selector.text_trunc_to_fit then -- not enough width
    local each_width = math.floor(remaining_width / #tabs)
    local remaining = remaining_width % each_width
    tabs_layout = "start"
    length_sum = width
    for _, tab in ipairs(tabs) do
      tab.text = text_layout( -- truncate text and pass it to "start"
        tab.text,
        "center",
        each_width + (tab.is_active and remaining or 0),
        trunc_char
      )
    end
  end
  if tabs_layout == "active" then
    local active_tab_length = width - length_sum + length_active
    for _, tab in ipairs(tabs) do
      return_string = return_string
        .. render_tab(
          tab.left,
          tab.right,
          tab.sep_hl,
          text_layout(
            tab.text,
            tab.is_active and content_layout or nil,
            active_tab_length,
            trunc_char
          ),
          tab.tab_hl,
          calc_click_id_from_source(winid, tab.index)
        )
        .. text_with_hl("", hl_background)
    end
  elseif tabs_layout == "equal" then
    for _, tab in ipairs(tabs) do
      return_string = return_string
        .. render_tab(
          tab.left,
          tab.right,
          tab.sep_hl,
          text_layout(tab.text, content_layout, math.floor(remaining_width / #tabs), trunc_char),
          tab.tab_hl,
          calc_click_id_from_source(winid, tab.index)
        )
        .. text_with_hl("", hl_background)
    end
  else -- config.source_selector.tab_labels == "start", "end", "center"
    -- calculate padding based on tabs_layout
    local pad_length = width - length_sum
    local left_pad, right_pad = 0, 0
    if pad_length > 0 then
      if tabs_layout == "start" then
        left_pad, right_pad = 0, pad_length
      elseif tabs_layout == "end" then
        left_pad, right_pad = pad_length, 0
      elseif tabs_layout == "center" then
        left_pad, right_pad = pad_length / 2, math.ceil(pad_length / 2)
      end
    end

    for i, tab in ipairs(tabs) do
      if width == 0 then
        break
      end

      -- only render trunc_char if there is no space for the tab
      local sep_length = tab.length - tab.text_length
      if width <= sep_length + 1 then
        return_string = return_string
          .. text_with_hl(trunc_char .. add_padding(width - 1), hl_background)
        width = 0
        break
      end

      -- tab_length should not exceed width
      local tab_length = width < tab.length and width or tab.length
      width = width - tab_length

      -- add padding for first and last tab
      local tab_text = tab.text
      if i == 1 then
        tab_text = add_padding(left_pad) .. tab_text
        tab_length = tab_length + left_pad
      end
      if i == #tabs then
        tab_text = tab_text .. add_padding(right_pad)
        tab_length = tab_length + right_pad
      end

      return_string = return_string
        .. render_tab(
          tab.left,
          tab.right,
          tab.sep_hl,
          text_layout(tab_text, tabs_layout, tab_length - sep_length, trunc_char),
          tab.tab_hl,
          calc_click_id_from_source(winid, tab.index)
        )
    end
  end
  return return_string .. "%<%0@v:lua.___neotree_selector_click@"
end

---set_source_selector:
-- (public): Directly set source_selector to current window's winbar / statusline
---@param state table: state
---@return nil
M.set_source_selector = function(state)
  local sel_config = utils.resolve_config_option(require("neo-tree").config, "source_selector", {})
  if sel_config and sel_config.winbar then
    vim.wo[state.winid].winbar = "%{%v:lua.require'neo-tree.ui.selector'.get()%}"
  end
  if sel_config and sel_config.statusline then
    vim.wo[state.winid].statusline = "%{%v:lua.require'neo-tree.ui.selector'.get()%}"
  end
end

-- @v:lua@ in the tabline only supports global functions, so this is
-- the only way to add click handlers without autoloaded vimscript functions
_G.___neotree_selector_click = function(id, _, _, _)
  if id < 1 then
    return
  end
  local sources = require("neo-tree").config.source_selector.sources
  local winid, source_index = calc_source_from_click_id(id)
  local state = manager.get_state_for_window(winid)
  if state == nil then
    log.warn("state not found for window ", winid, "; ignoring click")
    return
  end
  require("neo-tree.command").execute({
    source = sources[source_index].source,
    position = state.current_position,
    action = "focus",
  })
end

return M

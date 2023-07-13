local function to_string(text)
  if type(text) == "string" then
    return text
  end

  if type(text) == "table" and text.content then
    return text:content()
  end

  error("unsupported text")
end

local popup = {}

local mod = {}

mod.popup = popup

function mod.eq(...)
  return assert.are.same(...)
end

function mod.approx(...)
  return assert.are.near(...)
end

function mod.neq(...)
  return assert["not"].are.same(...)
end

---@param fn fun(): nil
---@param error string
---@param is_plain boolean
function mod.errors(fn, error, is_plain)
  assert.matches_error(fn, error, 1, is_plain)
end

---@param keys string
---@param mode string
function mod.feedkeys(keys, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode or "", true)
end

---@param tbl table
---@param keys string[]
function mod.tbl_pick(tbl, keys)
  if not keys or #keys == 0 then
    return tbl
  end

  local new_tbl = {}
  for _, key in ipairs(keys) do
    new_tbl[key] = tbl[key]
  end
  return new_tbl
end

---@param tbl table
---@param keys string[]
function mod.tbl_omit(tbl, keys)
  if not keys or #keys == 0 then
    return tbl
  end

  local new_tbl = vim.deepcopy(tbl)
  for _, key in ipairs(keys) do
    rawset(new_tbl, key, nil)
  end
  return new_tbl
end

---@param bufnr number
---@param ns_id integer
---@param linenr integer (1-indexed)
---@param byte_start? integer (0-indexed)
---@param byte_end? integer (0-indexed, inclusive)
function mod.get_line_extmarks(bufnr, ns_id, linenr, byte_start, byte_end)
  return vim.api.nvim_buf_get_extmarks(
    bufnr,
    ns_id,
    { linenr - 1, byte_start or 0 },
    { linenr - 1, byte_end and byte_end + 1 or -1 },
    { details = true }
  )
end

---@param bufnr number
---@param ns_id integer
---@param linenr integer (1-indexed)
---@param text string
---@return table[]
---@return { byte_start: integer, byte_end: integer } info (byte range: 0-indexed, inclusive)
function mod.get_text_extmarks(bufnr, ns_id, linenr, text)
  local line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1]

  local byte_start = string.find(line, text) -- 1-indexed
  byte_start = byte_start - 1 -- 0-indexed
  local byte_end = byte_start + #text - 1 -- inclusive

  local extmarks = vim.api.nvim_buf_get_extmarks(
    bufnr,
    ns_id,
    { linenr - 1, byte_start },
    { linenr - 1, byte_end },
    { details = true }
  )

  return extmarks, { byte_start = byte_start, byte_end = byte_end }
end

---@param bufnr number
---@param lines string[]
---@param linenr_start? integer (1-indexed)
---@param linenr_end? integer (1-indexed, inclusive)
function mod.assert_buf_lines(bufnr, lines, linenr_start, linenr_end)
  mod.eq(vim.api.nvim_buf_get_lines(bufnr, linenr_start and linenr_start - 1 or 0, linenr_end or -1, false), lines)
end

---@param bufnr number
---@param options table
function mod.assert_buf_options(bufnr, options)
  for name, value in pairs(options) do
    mod.eq(vim.api.nvim_buf_get_option(bufnr, name), value)
  end
end

---@param winid number
---@param options table
function mod.assert_win_options(winid, options)
  for name, value in pairs(options) do
    mod.eq(vim.api.nvim_win_get_option(winid, name), value)
  end
end

---@param extmark table
---@param linenr number (1-indexed)
---@param text string
---@param hl_group string
function mod.assert_extmark(extmark, linenr, text, hl_group)
  mod.eq(extmark[2], linenr - 1)

  if text then
    local start_col = extmark[3]
    mod.eq(extmark[4].end_col - start_col, #text)
  end

  mod.eq(mod.tbl_pick(extmark[4], { "end_row", "hl_group" }), {
    end_row = linenr - 1,
    hl_group = hl_group,
  })
end

---@param bufnr number
---@param ns_id integer
---@param linenr integer (1-indexed)
---@param text string
---@param hl_group string
function mod.assert_highlight(bufnr, ns_id, linenr, text, hl_group)
  local extmarks, info = mod.get_text_extmarks(bufnr, ns_id, linenr, text)

  mod.eq(#extmarks, 1)
  mod.eq(extmarks[1][3], info.byte_start)
  mod.assert_extmark(extmarks[1], linenr, text, hl_group)
end

---@param feature_name string
---@param desc string
---@param func fun(is_available: boolean):nil
function mod.describe_flipping_feature(feature_name, desc, func)
  local initial_value = require("nui.utils")._.feature[feature_name]

  describe(string.format("(w/ %s) %s", feature_name, desc), function()
    require("nui.utils")._.feature[feature_name] = true
    func(true)
    require("nui.utils")._.feature[feature_name] = initial_value
  end)

  describe(string.format("(w/o %s) %s", feature_name, desc), function()
    require("nui.utils")._.feature[feature_name] = false
    func(false)
    require("nui.utils")._.feature[feature_name] = initial_value
  end)
end

function popup.create_border_style_list()
  return { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
end

function popup.create_border_style_map()
  return {
    top_left = "╭",
    top = "─",
    top_right = "╮",
    left = "│",
    right = "│",
    bottom_left = "╰",
    bottom = "─",
    bottom_right = "╯",
  }
end

function popup.create_border_style_map_with_tuple(hl_group)
  local style = popup.create_border_style_map()
  for k, v in pairs(style) do
    style[k] = { v, hl_group .. "_" .. k }
  end
  return style
end

function popup.create_border_style_map_with_nui_text(hl_group)
  local Text = require("nui.text")

  local style = popup.create_border_style_map()
  for k, v in pairs(style) do
    style[k] = Text(v, hl_group .. "_" .. k)
  end

  return style
end

function popup.assert_border_lines(options, border_bufnr)
  local size = { width = options.size.width, height = options.size.height }

  local style = vim.deepcopy(options.border.style)
  if vim.tbl_islist(style) then
    style = {
      top_left = style[1],
      top = style[2],
      top_right = style[3],
      left = style[8],
      right = style[4],
      bottom_left = style[7],
      bottom = style[6],
      bottom_right = style[5],
    }
  end

  local expected_lines = {}
  table.insert(
    expected_lines,
    string.format(
      "%s%s%s",
      to_string(style.top_left),
      string.rep(to_string(style.top), size.width),
      to_string(style.top_right)
    )
  )
  for _ = 1, size.height do
    table.insert(
      expected_lines,
      string.format("%s%s%s", to_string(style.left), string.rep(" ", size.width), to_string(style.right))
    )
  end
  table.insert(
    expected_lines,
    string.format(
      "%s%s%s",
      to_string(style.bottom_left),
      string.rep(to_string(style.bottom), size.width),
      to_string(style.bottom_right)
    )
  )

  mod.assert_buf_lines(border_bufnr, expected_lines)
end

function popup.assert_border_highlight(options, border_bufnr, hl_group, no_hl_group_suffix)
  local size = { width = options.size.width, height = options.size.height }

  for linenr = 1, size.height + 2 do
    local is_top_line = linenr == 1
    local is_bottom_line = linenr == size.height + 2

    local extmarks = mod.get_line_extmarks(border_bufnr, options.ns_id, linenr)

    mod.eq(#extmarks, (is_top_line or is_bottom_line) and 4 or 2)

    local function with_suffix(hl_group_name, suffix)
      if no_hl_group_suffix then
        return hl_group_name
      end
      return hl_group_name .. suffix
    end

    mod.assert_extmark(
      extmarks[1],
      linenr,
      nil,
      with_suffix(hl_group, (is_top_line and "_top_left" or is_bottom_line and "_bottom_left" or "_left"))
    )

    if is_top_line or is_bottom_line then
      mod.assert_extmark(extmarks[2], linenr, nil, with_suffix(hl_group, (is_top_line and "_top" or "_bottom")))
      mod.assert_extmark(extmarks[3], linenr, nil, with_suffix(hl_group, (is_top_line and "_top" or "_bottom")))
    end

    mod.assert_extmark(
      extmarks[#extmarks],
      linenr,
      nil,
      with_suffix(hl_group, (is_top_line and "_top_right" or is_bottom_line and "_bottom_right" or "_right"))
    )
  end
end

return mod

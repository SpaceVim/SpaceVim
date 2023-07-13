local Object = require("nui.object")
local _ = require("nui.utils")._
local is_type = require("nui.utils").is_type

---@class NuiText
---@field protected extmark? table|{ id?: number, hl_group: string }
local Text = Object("NuiText")

---@param content string|NuiText text content or NuiText object
---@param extmark? string|table highlight group name or extmark options
function Text:init(content, extmark)
  if is_type("table", content) then
    -- cloning
    self:set(content._content, extmark or content.extmark)
  else
    self:set(content, extmark)
  end
end

---@param content string text content
---@param extmark? string|table highlight group name or extmark options
---@return NuiText
function Text:set(content, extmark)
  if self._content ~= content then
    self._content = content
    self._length = vim.fn.strlen(content)
    self._width = vim.api.nvim_strwidth(content)
  end

  if extmark then
    -- preserve self.extmark.id
    local id = self.extmark and self.extmark.id or nil
    self.extmark = is_type("string", extmark) and { hl_group = extmark } or vim.deepcopy(extmark)
    self.extmark.id = id
  end

  return self
end

---@return string
function Text:content()
  return self._content
end

---@return number
function Text:length()
  return self._length
end

---@return number
function Text:width()
  return self._width
end

---@param bufnr number buffer number
---@param ns_id number namespace id
---@param linenr number line number (1-indexed)
---@param byte_start number start byte position (0-indexed)
---@return nil
function Text:highlight(bufnr, ns_id, linenr, byte_start)
  if not self.extmark then
    return
  end

  self.extmark.end_col = byte_start + self:length()

  self.extmark.id = vim.api.nvim_buf_set_extmark(
    bufnr,
    _.ensure_namespace_id(ns_id),
    linenr - 1,
    byte_start,
    self.extmark
  )
end

---@param bufnr number buffer number
---@param ns_id number namespace id
---@param linenr_start number start line number (1-indexed)
---@param byte_start number start byte position (0-indexed)
---@param linenr_end? number end line number (1-indexed)
---@param byte_end? number end byte position (0-indexed)
---@return nil
function Text:render(bufnr, ns_id, linenr_start, byte_start, linenr_end, byte_end)
  local row_start = linenr_start - 1
  local row_end = linenr_end and linenr_end - 1 or row_start

  local col_start = byte_start
  local col_end = byte_end or byte_start + self:length()

  local content = self:content()

  vim.api.nvim_buf_set_text(bufnr, row_start, col_start, row_end, col_end, { content })

  self:highlight(bufnr, ns_id, linenr_start, byte_start)
end

---@param bufnr number buffer number
---@param ns_id number namespace id
---@param linenr_start number start line number (1-indexed)
---@param char_start number start character position (0-indexed)
---@param linenr_end? number end line number (1-indexed)
---@param char_end? number end character position (0-indexed)
---@return nil
function Text:render_char(bufnr, ns_id, linenr_start, char_start, linenr_end, char_end)
  char_end = char_end or char_start + self:width()
  local byte_range = _.char_to_byte_range(bufnr, linenr_start, char_start, char_end)
  self:render(bufnr, ns_id, linenr_start, byte_range[1], linenr_end, byte_range[2])
end

---@alias NuiText.constructor fun(content: string|NuiText, extmark?: string|table): NuiText
---@type NuiText|NuiText.constructor
local NuiText = Text

return NuiText

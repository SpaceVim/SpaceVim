local Position = require('cmp_dictionary.kit.LSP.Position')

local Range = {}

---Return the value is range or not.
---@param v any
---@return boolean
function Range.is(v)
  return type(v) == 'table' and Position.is(v.start) and Position.is(v['end'])
end

---Return the range is empty or not.
---@param range cmp_dictionary.kit.LSP.Range
---@return boolean
function Range.empty(range)
  return range.start.line == range['end'].line and range.start.character == range['end'].character
end

---Convert range to utf8 from specified encoding.
---@param text_start string
---@param range cmp_dictionary.kit.LSP.Range
---@param from_encoding? cmp_dictionary.kit.LSP.PositionEncodingKind
---@return cmp_dictionary.kit.LSP.Range
function Range.to_utf8(text_start, text_end, range, from_encoding)
  return {
    start = Position.to_utf8(text_start, range.start, from_encoding),
    ['end'] = Position.to_utf8(text_end, range['end'], from_encoding),
  }
end

---Convert range to utf16 from specified encoding.
---@param text_start string
---@param range cmp_dictionary.kit.LSP.Range
---@param from_encoding? cmp_dictionary.kit.LSP.PositionEncodingKind
---@return cmp_dictionary.kit.LSP.Range
function Range.to_utf16(text_start, text_end, range, from_encoding)
  return {
    start = Position.to_utf16(text_start, range.start, from_encoding),
    ['end'] = Position.to_utf16(text_end, range['end'], from_encoding),
  }
end

---Convert range to utf32 from specified encoding.
---@param text_start string
---@param range cmp_dictionary.kit.LSP.Range
---@param from_encoding? cmp_dictionary.kit.LSP.PositionEncodingKind
---@return cmp_dictionary.kit.LSP.Range
function Range.to_utf32(text_start, text_end, range, from_encoding)
  return {
    start = Position.to_utf32(text_start, range.start, from_encoding),
    ['end'] = Position.to_utf32(text_end, range['end'], from_encoding),
  }
end

return Range

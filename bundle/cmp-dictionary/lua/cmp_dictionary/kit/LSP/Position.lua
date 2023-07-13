local LSP = require('cmp_dictionary.kit.LSP')

local Position = {}

---Return the value is position or not.
---@param v any
---@return boolean
function Position.is(v)
  local is = true
  is = is and (type(v) == 'table' and type(v.line) == 'number' and type(v.character) == 'number')
  return is
end

---Create a cursor position.
---@param encoding? cmp_dictionary.kit.LSP.PositionEncodingKind
function Position.cursor(encoding)
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  local utf8 = { line = r - 1, character = c }
  if encoding == LSP.PositionEncodingKind.UTF8 then
    return utf8
  else
    local text = vim.api.nvim_get_current_line()
    if encoding == LSP.PositionEncodingKind.UTF32 then
      return Position.to(text, utf8, LSP.PositionEncodingKind.UTF8, LSP.PositionEncodingKind.UTF32)
    end
    return Position.to(text, utf8, LSP.PositionEncodingKind.UTF8, LSP.PositionEncodingKind.UTF16)
  end
end

---Convert position to specified encoding from specified encoding.
---@param text string
---@param position cmp_dictionary.kit.LSP.Position
---@param from_encoding cmp_dictionary.kit.LSP.PositionEncodingKind
---@param to_encoding cmp_dictionary.kit.LSP.PositionEncodingKind
function Position.to(text, position, from_encoding, to_encoding)
  if to_encoding == LSP.PositionEncodingKind.UTF8 then
    return Position.to_utf8(text, position, from_encoding)
  elseif to_encoding == LSP.PositionEncodingKind.UTF16 then
    return Position.to_utf16(text, position, from_encoding)
  elseif to_encoding == LSP.PositionEncodingKind.UTF32 then
    return Position.to_utf32(text, position, from_encoding)
  end
  error('LSP.Position: Unsupported encoding: ' .. to_encoding)
end

---Convert position to utf8 from specified encoding.
---@param text string
---@param position cmp_dictionary.kit.LSP.Position
---@param from_encoding? cmp_dictionary.kit.LSP.PositionEncodingKind
---@return cmp_dictionary.kit.LSP.Position
function Position.to_utf8(text, position, from_encoding)
  from_encoding = from_encoding or LSP.PositionEncodingKind.UTF16
  if from_encoding == LSP.PositionEncodingKind.UTF8 then
    return position
  end
  local ok, byteindex = pcall(function()
    return vim.str_byteindex(text, position.character, from_encoding == LSP.PositionEncodingKind.UTF16)
  end)
  if ok then
    position = { line = position.line, character = byteindex }
  end
  return position
end

---Convert position to utf16 from specified encoding.
---@param text string
---@param position cmp_dictionary.kit.LSP.Position
---@param from_encoding? cmp_dictionary.kit.LSP.PositionEncodingKind
---@return cmp_dictionary.kit.LSP.Position
function Position.to_utf16(text, position, from_encoding)
  local utf8 = Position.to_utf8(text, position, from_encoding)
  for index = utf8.character, 0, -1 do
    local ok, utf16index = pcall(function()
      return select(2, vim.str_utfindex(text, index))
    end)
    if ok then
      position = { line = utf8.line, character = utf16index }
      break
    end
  end
  return position
end

---Convert position to utf32 from specified encoding.
---@param text string
---@param position cmp_dictionary.kit.LSP.Position
---@param from_encoding? cmp_dictionary.kit.LSP.PositionEncodingKind
---@return cmp_dictionary.kit.LSP.Position
function Position.to_utf32(text, position, from_encoding)
  local utf8 = Position.to_utf8(text, position, from_encoding)
  for index = utf8.character, 0, -1 do
    local ok, utf32index = pcall(function()
      return select(1, vim.str_utfindex(text, index))
    end)
    if ok then
      position = { line = utf8.line, character = utf32index }
      break
    end
  end
  return position
end

return Position

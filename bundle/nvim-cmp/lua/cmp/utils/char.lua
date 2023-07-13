local _

local alpha = {}
_ = string.gsub('abcdefghijklmnopqrstuvwxyz', '.', function(char)
  alpha[string.byte(char)] = true
end)

local ALPHA = {}
_ = string.gsub('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '.', function(char)
  ALPHA[string.byte(char)] = true
end)

local digit = {}
_ = string.gsub('1234567890', '.', function(char)
  digit[string.byte(char)] = true
end)

local white = {}
_ = string.gsub(' \t\n', '.', function(char)
  white[string.byte(char)] = true
end)

local char = {}

---@param byte integer
---@return boolean
char.is_upper = function(byte)
  return ALPHA[byte]
end

---@param byte integer
---@return boolean
char.is_alpha = function(byte)
  return alpha[byte] or ALPHA[byte]
end

---@param byte integer
---@return boolean
char.is_digit = function(byte)
  return digit[byte]
end

---@param byte integer
---@return boolean
char.is_white = function(byte)
  return white[byte]
end

---@param byte integer
---@return boolean
char.is_symbol = function(byte)
  return not (char.is_alnum(byte) or char.is_white(byte))
end

---@param byte integer
---@return boolean
char.is_printable = function(byte)
  return string.match(string.char(byte), '^%c$') == nil
end

---@param byte integer
---@return boolean
char.is_alnum = function(byte)
  return char.is_alpha(byte) or char.is_digit(byte)
end

---@param text string
---@param index integer
---@return boolean
char.is_semantic_index = function(text, index)
  if index <= 1 then
    return true
  end

  local prev = string.byte(text, index - 1)
  local curr = string.byte(text, index)

  if not char.is_upper(prev) and char.is_upper(curr) then
    return true
  end
  if char.is_symbol(curr) or char.is_white(curr) then
    return true
  end
  if not char.is_alpha(prev) and char.is_alpha(curr) then
    return true
  end
  if not char.is_digit(prev) and char.is_digit(curr) then
    return true
  end
  return false
end

---@param text string
---@param current_index integer
---@return integer
char.get_next_semantic_index = function(text, current_index)
  for i = current_index + 1, #text do
    if char.is_semantic_index(text, i) then
      return i
    end
  end
  return #text + 1
end

---Ignore case match
---@param byte1 integer
---@param byte2 integer
---@return boolean
char.match = function(byte1, byte2)
  if not char.is_alpha(byte1) or not char.is_alpha(byte2) then
    return byte1 == byte2
  end
  local diff = byte1 - byte2
  return diff == 0 or diff == 32 or diff == -32
end

return char

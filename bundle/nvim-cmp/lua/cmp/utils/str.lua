local char = require('cmp.utils.char')

local str = {}

local INVALIDS = {}
INVALIDS[string.byte("'")] = true
INVALIDS[string.byte('"')] = true
INVALIDS[string.byte('=')] = true
INVALIDS[string.byte('$')] = true
INVALIDS[string.byte('(')] = true
INVALIDS[string.byte('[')] = true
INVALIDS[string.byte('<')] = true
INVALIDS[string.byte('{')] = true
INVALIDS[string.byte(' ')] = true
INVALIDS[string.byte('\t')] = true
INVALIDS[string.byte('\n')] = true
INVALIDS[string.byte('\r')] = true

local NR_BYTE = string.byte('\n')

local PAIRS = {}
PAIRS[string.byte('<')] = string.byte('>')
PAIRS[string.byte('[')] = string.byte(']')
PAIRS[string.byte('(')] = string.byte(')')
PAIRS[string.byte('{')] = string.byte('}')
PAIRS[string.byte('"')] = string.byte('"')
PAIRS[string.byte("'")] = string.byte("'")

---Return if specified text has prefix or not
---@param text string
---@param prefix string
---@return boolean
str.has_prefix = function(text, prefix)
  if #text < #prefix then
    return false
  end
  for i = 1, #prefix do
    if not char.match(string.byte(text, i), string.byte(prefix, i)) then
      return false
    end
  end
  return true
end

---get_common_string
str.get_common_string = function(text1, text2)
  local min = math.min(#text1, #text2)
  for i = 1, min do
    if not char.match(string.byte(text1, i), string.byte(text2, i)) then
      return string.sub(text1, 1, i - 1)
    end
  end
  return string.sub(text1, 1, min)
end

---Remove suffix
---@param text string
---@param suffix string
---@return string
str.remove_suffix = function(text, suffix)
  if #text < #suffix then
    return text
  end

  local i = 0
  while i < #suffix do
    if string.byte(text, #text - i) ~= string.byte(suffix, #suffix - i) then
      return text
    end
    i = i + 1
  end
  return string.sub(text, 1, -#suffix - 1)
end

---trim
---@param text string
---@return string
str.trim = function(text)
  local s = 1
  for i = 1, #text do
    if not char.is_white(string.byte(text, i)) then
      s = i
      break
    end
  end

  local e = #text
  for i = #text, 1, -1 do
    if not char.is_white(string.byte(text, i)) then
      e = i
      break
    end
  end
  if s == 1 and e == #text then
    return text
  end
  return string.sub(text, s, e)
end

---get_word
---@param text string
---@param stop_char? integer
---@param min_length? integer
---@return string
str.get_word = function(text, stop_char, min_length)
  min_length = min_length or 0

  local has_alnum = false
  local stack = {}
  local word = {}
  local add = function(c)
    table.insert(word, string.char(c))
    if stack[#stack] == c then
      table.remove(stack, #stack)
    else
      if PAIRS[c] then
        table.insert(stack, c)
      end
    end
  end
  for i = 1, #text do
    local c = string.byte(text, i, i)
    if #word < min_length then
      table.insert(word, string.char(c))
    elseif not INVALIDS[c] then
      add(c)
      has_alnum = has_alnum or char.is_alnum(c)
    elseif not has_alnum then
      add(c)
    elseif #stack ~= 0 then
      add(c)
      if has_alnum and #stack == 0 then
        break
      end
    else
      break
    end
  end
  if stop_char and word[#word] == string.char(stop_char) then
    table.remove(word, #word)
  end
  return table.concat(word, '')
end

---Oneline
---@param text string
---@return string
str.oneline = function(text)
  for i = 1, #text do
    if string.byte(text, i) == NR_BYTE then
      return string.sub(text, 1, i - 1)
    end
  end
  return text
end

---Escape special chars
---@param text string
---@param chars string[]
---@return string
str.escape = function(text, chars)
  table.insert(chars, '\\')
  local escaped = {}
  local i = 1
  while i <= #text do
    local c = string.sub(text, i, i)
    if vim.tbl_contains(chars, c) then
      table.insert(escaped, '\\')
      table.insert(escaped, c)
    else
      table.insert(escaped, c)
    end
    i = i + 1
  end
  return table.concat(escaped, '')
end

return str

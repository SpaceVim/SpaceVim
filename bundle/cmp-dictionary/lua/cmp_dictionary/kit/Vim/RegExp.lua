local RegExp = {}

---@type table<string, { match_str: fun(self, text: string) }>
RegExp._cache = {}

---Create a RegExp object.
---@param pattern string
---@return { match_str: fun(self, text: string) }
function RegExp.get(pattern)
  if not RegExp._cache[pattern] then
    RegExp._cache[pattern] = vim.regex(pattern)
  end
  return RegExp._cache[pattern]
end

---Grep and substitute text.
---@param text string
---@param pattern string
---@param replacement string
---@return string
function RegExp.gsub(text, pattern, replacement)
  return vim.fn.substitute(text, pattern, replacement, 'g')
end

---Match pattern in text for specified position.
---@param text string
---@param pattern string
---@param pos number 1-origin index
---@return string?, integer?, integer? 1-origin-index
function RegExp.extract_at(text, pattern, pos)
  local before_text = text:sub(1, pos - 1)
  local after_text = text:sub(pos)
  local b_s, _ = RegExp.get(pattern .. '$'):match_str(before_text)
  local _, a_e = RegExp.get('^' .. pattern):match_str(after_text)
  if b_s or a_e then
    b_s = b_s or #before_text
    a_e = #before_text + (a_e or 0)
    return text:sub(b_s + 1, a_e), b_s + 1, a_e + 1
  end
end

return RegExp

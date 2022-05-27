-- based on https://github.com/sindresorhus/strip-json-comments

local singleComment = "singleComment"
local multiComment = "multiComment"
local stripWithoutWhitespace = function()
  return ""
end

local function slice(str, from, to)
  from = from or 1
  to = to or #str
  return str:sub(from, to)
end

local stripWithWhitespace = function(str, from, to)
  return slice(str, from, to):gsub("%S", " ")
end

local isEscaped = function(jsonString, quotePosition)
  local index = quotePosition - 1
  local backslashCount = 0

  while jsonString:sub(index, index) == "\\" do
    index = index - 1
    backslashCount = backslashCount + 1
  end
  return backslashCount % 2 == 1 and true or false
end

local M = {}

-- Strips any json comments from a json string.
-- The resulting string can then be used by `vim.fn.json_decode`
--
---@param jsonString string
---@param options table
---  * whitespace:
---     - defaults to true
---     - when true, comments will be replaced by whitespace
---     - when false, comments will be stripped
function M.json_strip_comments(jsonString, options)
  options = options or {}
  local strip = options.whitespace == false and stripWithoutWhitespace or stripWithWhitespace

  local insideString = false
  local insideComment = false
  local offset = 1
  local result = ""
  local skip = false

  for i = 1, #jsonString, 1 do
    if skip then
      skip = false
    else
      local currentCharacter = jsonString:sub(i, i)
      local nextCharacter = jsonString:sub(i + 1, i + 1)

      if not insideComment and currentCharacter == '"' then
        local escaped = isEscaped(jsonString, i)
        if not escaped then
          insideString = not insideString
        end
      end

      if not insideString then
        if not insideComment and currentCharacter .. nextCharacter == "//" then
          result = result .. slice(jsonString, offset, i - 1)
          offset = i
          insideComment = singleComment
          i = i + 1
          skip = true
        elseif insideComment == singleComment and currentCharacter .. nextCharacter == "\r\n" then
          i = i + 1
          skip = true
          insideComment = false
          result = result .. strip(jsonString, offset, i - 1)
          offset = i
        elseif insideComment == singleComment and currentCharacter == "\n" then
          insideComment = false
          result = result .. strip(jsonString, offset, i - 1)
          offset = i
        elseif not insideComment and currentCharacter .. nextCharacter == "/*" then
          result = result .. slice(jsonString, offset, i - 1)
          offset = i
          insideComment = multiComment
          i = i + 1
          skip = true
        elseif insideComment == multiComment and currentCharacter .. nextCharacter == "*/" then
          i = i + 1
          skip = true
          insideComment = false
          result = result .. strip(jsonString, offset, i)
          offset = i + 1
        end
      end
    end
  end

  return result .. (insideComment and strip(slice(jsonString, offset)) or slice(jsonString, offset))
end

return M

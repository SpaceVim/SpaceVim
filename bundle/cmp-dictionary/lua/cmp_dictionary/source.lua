local source = {}

local utf8 = require("cmp_dictionary.lib.utf8")
local config = require("cmp_dictionary.config")
local caches = require("cmp_dictionary.caches")
local db = require("cmp_dictionary.db")

function source.new()
  return setmetatable({}, { __index = source })
end

---@return string
function source.get_keyword_pattern()
  return [[\k\+]]
end

local candidate_cache = {
  req = "",
  items = {},
}

---@param str string
---@return boolean
local function is_capital(str)
  return str:find("^%u") and true or false
end

---@param str string
---@return string
local function to_lower_first(str)
  local l = str:gsub("^.", string.lower)
  return l
end

---@param str string
---@return string
local function to_upper_first(str)
  local u = str:gsub("^.", string.upper)
  return u
end

---@param req string
---@param isIncomplete boolean
---@return table
function source.get_candidate(req, isIncomplete)
  if candidate_cache.req == req then
    return { items = candidate_cache.items, isIncomplete = isIncomplete }
  end

  local items
  local request = config.get("sqlite") and db.request or caches.request
  items, isIncomplete = request(req, isIncomplete)

  if config.get("first_case_insensitive") then
    local pre, post = to_upper_first, to_lower_first
    if is_capital(req) then
      pre, post = post, pre
    end
    for _, item in ipairs(request(pre(req), isIncomplete)) do
      table.insert(items, { label = post(item.label), detail = item.detail })
    end
  end

  candidate_cache.req = req
  candidate_cache.items = items

  return { items = items, isIncomplete = isIncomplete }
end

---@param request cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source.complete(_, request, callback)
  -- Clear the cache since the dictionary has been updated.
  if config.get("sqlite") then
    if db.is_just_updated() then
      candidate_cache = {}
    end
  else
    if caches.is_just_updated() then
      candidate_cache = {}
    end
  end

  local exact = config.get("exact")

  ---@type string
  local line = request.context.cursor_before_line
  local offset = request.offset
  line = line:sub(offset)
  if line == "" then
    return
  end

  local req, isIncomplete
  if exact > 0 then
    local line_len = utf8.len(line)
    if line_len <= exact then
      req = line
      isIncomplete = line_len < exact
    else
      local last = exact
      if line_len ~= #line then
        last = utf8.offset(line, exact + 1) - 1
      end
      req = line:sub(1, last)
      isIncomplete = false
    end
  else
    -- must be -1
    req = line
    isIncomplete = true
  end

  callback(source.get_candidate(req, isIncomplete))
end

function source.resolve(_, completion_item, callback)
  if config.get("sqlite") then
    db.document(completion_item, callback)
  else
    require("cmp_dictionary.document")(completion_item, callback)
  end
end

return source

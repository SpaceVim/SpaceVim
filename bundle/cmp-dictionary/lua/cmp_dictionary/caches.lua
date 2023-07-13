local util = require("cmp_dictionary.util")
local lfu = require("cmp_dictionary.lfu")
local config = require("cmp_dictionary.config")
local utf8 = require("cmp_dictionary.lib.utf8")
local Async = require("cmp_dictionary.kit.Async")
local Worker = require("cmp_dictionary.kit.Thread.Worker")

---@class DictionaryData
---@field items lsp.CompletionItem[]
---@field mtime integer
---@field path string

local Caches = {
  ---@type DictionaryData[]
  valid = {},
}

local just_updated = false
local dictCache = lfu.init(config.get("capacity"))

---Filter to keep only dictionaries that have been updated or have not yet been cached.
---@return {path: string, mtime: integer}[]
local function need_to_load()
  local dictionaries = util.get_dictionaries()
  local updated_or_new = {}
  for _, dict in ipairs(dictionaries) do
    local path = vim.fn.expand(dict)
    if util.bool_fn.filereadable(path) then
      local mtime = vim.fn.getftime(path)
      local cache = dictCache:get(path)
      if cache and cache.mtime == mtime then
        table.insert(Caches.valid, cache)
      else
        table.insert(updated_or_new, { path = path, mtime = mtime })
      end
    end
  end
  return updated_or_new
end

---Create dictionary data from buffers
---@param path string
---@param name string
---@return lsp.CompletionItem[] items
local read_items = Worker.new(function(path, name)
  local buffer = require("cmp_dictionary.util").read_file_sync(path)

  local items = {}
  local detail = ("belong to `%s`"):format(name)
  for w in vim.gsplit(buffer, "%s+") do
    if w ~= "" then
      table.insert(items, { label = w, detail = detail })
    end
  end
  table.sort(items, function(item1, item2)
    return item1.label < item2.label
  end)

  return items
end)

---@param path string
---@param mtime integer
---@return cmp_dictionary.kit.Async.AsyncTask
local function cache_update(path, mtime)
  local name = vim.fn.fnamemodify(path, ":t")
  return read_items(path, name):next(function(items)
    local cache = {
      items = items,
      mtime = mtime,
      path = path,
    }
    dictCache:set(path, cache)
    table.insert(Caches.valid, cache)
  end)
end

local function update()
  local buftype = vim.api.nvim_buf_get_option(0, "buftype")
  if buftype ~= "" then
    return
  end

  Caches.valid = {}

  Async.all(vim.tbl_map(function(n)
    return cache_update(n.path, n.mtime)
  end, need_to_load())):next(function()
    just_updated = true
  end)
end

function Caches.update()
  util.debounce("update", update, 100)
end

---@param req string
---@param isIncomplete boolean
---@return lsp.CompletionItem[] items
---@return boolean isIncomplete
function Caches.request(req, isIncomplete)
  local items = {}
  isIncomplete = isIncomplete or false

  local ok, offset, codepoint
  ok, offset = pcall(utf8.offset, req, -1)
  if not ok then
    return items, isIncomplete
  end
  ok, codepoint = pcall(utf8.codepoint, req, offset)
  if not ok then
    return items, isIncomplete
  end

  local req_next = req:sub(1, offset - 1) .. utf8.char(codepoint + 1)

  local max_items = config.get("max_items")
  for _, cache in pairs(Caches.valid) do
    local start = util.binary_search(cache.items, req, function(vector, index, key)
      return vector[index].label >= key
    end)
    local last = util.binary_search(cache.items, req_next, function(vector, index, key)
      return vector[index].label >= key
    end) - 1
    if start > 0 and last > 0 and start <= last then
      if max_items > 0 and last >= start + max_items then
        last = start + max_items
        isIncomplete = true
      end
      for i = start, last do
        local item = cache.items[i]
        table.insert(items, item)
      end
    end
  end
  return items, isIncomplete
end

function Caches.is_just_updated()
  if just_updated then
    just_updated = false
    return true
  end
  return false
end

return Caches

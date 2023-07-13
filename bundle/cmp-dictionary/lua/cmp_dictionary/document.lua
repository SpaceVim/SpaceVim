local config = require("cmp_dictionary.config")

local document_cache = require("cmp_dictionary.lfu").init(100)

---@param word string
---@return string
---@return string[]
local function get_command(word)
  local command = config.get("document_command")

  local args
  if type(command) == "table" then
    -- copy
    args = {}
    for i, v in ipairs(command) do
      args[i] = v
    end
  elseif type(command) == "string" then
    args = vim.split(command, " ")
  end

  local cmd = table.remove(args, 1)
  for i, arg in ipairs(args) do
    if arg:find("%s", 1, true) then
      args[i] = arg:format(word)
    end
  end

  return cmd, args
end

---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
local function get_document(completion_item, callback)
  local ok, Job = pcall(require, "plenary.job")
  if not ok then
    vim.notify("[cmp-dictionary] document feature requires plenary.nvim")
    return
  end

  local word = completion_item.label
  local command, args = get_command(word)
  if not command then
    callback(completion_item)
    return
  end

  Job:new({
    command = command,
    args = args,
    on_exit = vim.schedule_wrap(function(j)
      local result = table.concat(j:result(), "\n")
      document_cache:set(word, result)
      completion_item.documentation = result
      callback(completion_item)
    end),
  }):start()
end

---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
local function resolve(completion_item, callback)
  if config.get("document") then
    local cached = document_cache:get(completion_item.label)
    if cached then
      completion_item.documentation = cached
      callback(completion_item)
    else
      get_document(completion_item, callback)
    end
  else
    callback(completion_item)
  end
end

return resolve

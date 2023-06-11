local kit = require('cmp_dictionary.kit')
local Async = require('cmp_dictionary.kit.Async')

---@alias cmp_dictionary.kit.Vim.Keymap.Keys { keys: string, remap: boolean }
---@alias cmp_dictionary.kit.Vim.Keymap.KeysSpecifier string|{ keys: string, remap: boolean }

---@param keys cmp_dictionary.kit.Vim.Keymap.KeysSpecifier
---@return cmp_dictionary.kit.Vim.Keymap.Keys
local function to_keys(keys)
  if type(keys) == 'table' then
    return keys
  end
  return { keys = keys, remap = false }
end

local Keymap = {}

Keymap._callbacks = {}

---Replace termcodes.
---@param keys string
---@return string
function Keymap.termcodes(keys)
  return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

---Set callback for consuming next typeahead.
---@param callback fun()
---@return cmp_dictionary.kit.Async.AsyncTask
function Keymap.next(callback)
  return Keymap.send(''):next(callback)
end

---Send keys.
---@param keys cmp_dictionary.kit.Vim.Keymap.KeysSpecifier|cmp_dictionary.kit.Vim.Keymap.KeysSpecifier[]
---@param no_insert? boolean
---@return cmp_dictionary.kit.Async.AsyncTask
function Keymap.send(keys, no_insert)
  local unique_id = kit.unique_id()
  return Async.new(function(resolve, _)
    Keymap._callbacks[unique_id] = resolve

    local callback = Keymap.termcodes(('<Cmd>lua require("cmp_dictionary.kit.Vim.Keymap")._resolve(%s)<CR>'):format(unique_id))
    if no_insert then
      for _, keys_ in ipairs(kit.to_array(keys)) do
        keys_ = to_keys(keys_)
        vim.api.nvim_feedkeys(keys_.keys, keys_.remap and 'm' or 'n', true)
      end
      vim.api.nvim_feedkeys(callback, 'n', true)
    else
      vim.api.nvim_feedkeys(callback, 'in', true)
      for _, keys_ in ipairs(kit.reverse(kit.to_array(keys))) do
        keys_ = to_keys(keys_)
        vim.api.nvim_feedkeys(keys_.keys, 'i' .. (keys_.remap and 'm' or 'n'), true)
      end
    end
  end):catch(function()
    Keymap._callbacks[unique_id] = nil
  end)
end

---Return sendabke keys with callback function.
---@param callback fun(...: any): any
---@return string
function Keymap.to_sendable(callback)
  local unique_id = kit.unique_id()
  Keymap._callbacks[unique_id] = Async.async(callback)
  return Keymap.termcodes(('<Cmd>lua require("cmp_dictionary.kit.Vim.Keymap")._resolve(%s)<CR>'):format(unique_id))
end

---Test spec helper.
---@param spec fun(): any
function Keymap.spec(spec)
  local task = Async.resolve():next(Async.async(spec))
  vim.api.nvim_feedkeys('', 'x', true)
  task:sync()
  collectgarbage('collect')
  vim.wait(200)
end

---Resolve running keys.
---@param unique_id integer
function Keymap._resolve(unique_id)
  Keymap._callbacks[unique_id]()
  Keymap._callbacks[unique_id] = nil
end

return Keymap

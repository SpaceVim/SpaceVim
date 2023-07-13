local buf_storage = require("nui.utils.buf_storage")
local is_type = require("nui.utils").is_type
local feature = require("nui.utils")._.feature

local keymap = {
  storage = buf_storage.create("nui.utils.keymap", { _next_handler_id = 1, keys = {}, handlers = {} }),
}

---@param mode string
---@param key string
---@return string key_id
local function get_key_id(mode, key)
  return string.format("%s---%s", mode, vim.api.nvim_replace_termcodes(key, true, true, true))
end

---@param bufnr number
---@param key_id string
---@return number|nil handler_id
local function get_handler_id(bufnr, key_id)
  return keymap.storage[bufnr].keys[key_id]
end

---@param bufnr number
---@param key_id string
---@return number|nil handler_id
local function next_handler_id(bufnr, key_id)
  local handler_id = keymap.storage[bufnr]._next_handler_id
  keymap.storage[bufnr].keys[key_id] = handler_id
  keymap.storage[bufnr]._next_handler_id = handler_id + 1
  return handler_id
end

---@param bufnr number
---@param mode string
---@param key string
---@param handler string|fun(): nil
---@return { rhs: string, callback?: fun(): nil }|nil
local function get_keymap_info(bufnr, mode, key, handler, overwrite)
  local key_id = get_key_id(mode, key)

  -- luacov: disable
  if get_handler_id(bufnr, key_id) and not overwrite then
    return nil
  end
  -- luacov: enable

  local handler_id = next_handler_id(bufnr, key_id)

  local rhs, callback = "", nil

  if is_type("function", handler) then
    if feature.lua_keymap then
      callback = handler
    else
      keymap.storage[bufnr].handlers[handler_id] = handler
      rhs = string.format("<cmd>lua require('nui.utils.keymap').execute(%s, %s)<CR>", bufnr, handler_id)
    end
  else
    rhs = handler
  end

  return {
    rhs = rhs,
    callback = callback,
  }
end

---@param bufnr number
---@param handler_id number
function keymap.execute(bufnr, handler_id)
  local handler = keymap.storage[bufnr].handlers[handler_id]
  if is_type("function", handler) then
    handler(bufnr)
  end
end

---@param bufnr number
---@param mode string
---@param lhs string|string[]
---@param handler string|fun(): nil
---@param opts table<"'expr'"|"'noremap'"|"'nowait'"|"'remap'"|"'script'"|"'silent'"|"'unique'", boolean>
---@return nil
function keymap.set(bufnr, mode, lhs, handler, opts, force)
  if feature.lua_keymap and not is_type("boolean", force) then
    force = true
  end

  local keys = is_type("table", lhs) and lhs or { lhs }

  opts = opts or {}

  if not is_type("nil", opts.remap) then
    opts.noremap = not opts.remap
    opts.remap = nil
  end

  for _, key in ipairs(keys) do
    local keymap_info = get_keymap_info(bufnr, mode, key, handler, force)
    -- luacov: disable
    if not keymap_info then
      return false
    end
    -- luacov: enable

    local options = vim.deepcopy(opts)
    options.callback = keymap_info.callback

    vim.api.nvim_buf_set_keymap(bufnr, mode, key, keymap_info.rhs, options)
  end

  return true
end

---@param bufnr number
---@param mode string
---@param lhs string|string[]
---@return nil
function keymap._del(bufnr, mode, lhs, force)
  if feature.lua_keymap and not is_type("boolean", force) then
    force = true
  end

  local keys = is_type("table", lhs) and lhs or { lhs }

  for _, key in ipairs(keys) do
    local key_id = get_key_id(mode, key)

    local handler_id = get_handler_id(bufnr, key_id)

    -- luacov: disable
    if not handler_id and not force then
      return false
    end
    -- luacov: enable

    keymap.storage[bufnr].keys[key_id] = nil
    keymap.storage[bufnr].handlers[handler_id] = nil

    vim.api.nvim_buf_del_keymap(bufnr, mode, key)
  end

  return true
end

return keymap

local defaults = require("nui.utils").defaults

local buf_storage = {
  _registry = {},
}

---@param storage_name string
---@param default_value any
---@return table<number, any>
function buf_storage.create(storage_name, default_value)
  local storage = setmetatable({}, {
    __index = function(tbl, bufnr)
      rawset(tbl, bufnr, vim.deepcopy(defaults(default_value, {})))

      -- TODO: can `buf_storage.cleanup` be automatically (and reliably) triggered on `BufWipeout`?

      return tbl[bufnr]
    end,
  })

  buf_storage._registry[storage_name] = storage

  return storage
end

---@param bufnr number
function buf_storage.cleanup(bufnr)
  for _, storage in pairs(buf_storage._registry) do
    rawset(storage, bufnr, nil)
  end
end

return buf_storage

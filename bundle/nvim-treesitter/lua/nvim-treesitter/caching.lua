local api = vim.api

local M = {}

--- Creates a cache table for buffers keyed by a type name.
--- Cache entries attach to the buffer and cleanup entries
--- as buffers are detached.
function M.create_buffer_cache()
  local cache = {}

  local items = setmetatable({}, {
    __index = function(tbl, key)
      rawset(tbl, key, {})
      return rawget(tbl, key)
    end,
  })

  function cache.set(type_name, bufnr, value)
    if not cache.has(type_name, bufnr) then
      -- Clean up the cache if the buffer is detached
      -- to avoid memory leaks
      api.nvim_buf_attach(bufnr, false, {
        on_detach = function()
          cache.remove(type_name, bufnr)
          return true
        end,
      })
    end

    items[type_name][bufnr] = value
  end

  function cache.get(type_name, bufnr)
    return items[type_name][bufnr]
  end

  function cache.has(type_name, bufnr)
    return cache.get(type_name, bufnr) ~= nil
  end

  function cache.remove(type_name, bufnr)
    items[type_name][bufnr] = nil
  end

  return cache
end

return M

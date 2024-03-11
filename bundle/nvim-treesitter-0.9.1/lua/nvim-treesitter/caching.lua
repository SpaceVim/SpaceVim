local api = vim.api

local M = {}

-- Creates a cache table for buffers keyed by a type name.
-- Cache entries attach to the buffer and cleanup entries
-- as buffers are detached.
function M.create_buffer_cache()
  local cache = {}

  ---@type table<integer, table<string, any>>
  local items = setmetatable({}, {
    __index = function(tbl, key)
      rawset(tbl, key, {})
      return rawget(tbl, key)
    end,
  })

  ---@type table<integer, boolean>
  local loaded_buffers = {}

  ---@param type_name string
  ---@param bufnr integer
  ---@param value any
  function cache.set(type_name, bufnr, value)
    if not loaded_buffers[bufnr] then
      loaded_buffers[bufnr] = true
      -- Clean up the cache if the buffer is detached
      -- to avoid memory leaks
      api.nvim_buf_attach(bufnr, false, {
        on_detach = function()
          cache.clear_buffer(bufnr)
          loaded_buffers[bufnr] = nil
          return true
        end,
        on_reload = function() end, -- this is needed to prevent on_detach being called on buffer reload
      })
    end

    items[bufnr][type_name] = value
  end

  ---@param type_name string
  ---@param bufnr integer
  ---@return any
  function cache.get(type_name, bufnr)
    return items[bufnr][type_name]
  end

  ---@param type_name string
  ---@param bufnr integer
  ---@return boolean
  function cache.has(type_name, bufnr)
    return cache.get(type_name, bufnr) ~= nil
  end

  ---@param type_name string
  ---@param bufnr integer
  function cache.remove(type_name, bufnr)
    items[bufnr][type_name] = nil
  end

  ---@param bufnr integer
  function cache.clear_buffer(bufnr)
    items[bufnr] = nil
  end

  return cache
end

return M

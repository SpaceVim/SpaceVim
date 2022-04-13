local mapping
mapping = setmetatable({}, {
  __call = function(_, invoke, modes)
    if type(invoke) == 'function' then
      local map = {}
      for _, mode in ipairs(modes or { 'i' }) do
        map[mode] = invoke
      end
      return map
    end
    return invoke
  end,
})

---Invoke completion
---@param option cmp.CompleteParams
mapping.complete = function(option)
  return function(fallback)
    if not require('cmp').complete(option) then
      fallback()
    end
  end
end

---Complete common string.
mapping.complete_common_string = function()
  return function(fallback)
    if not require('cmp').complete_common_string() then
      fallback()
    end
  end
end

---Close current completion menu if it displayed.
mapping.close = function()
  return function(fallback)
    if not require('cmp').close() then
      fallback()
    end
  end
end

---Abort current completion menu if it displayed.
mapping.abort = function()
  return function(fallback)
    if not require('cmp').abort() then
      fallback()
    end
  end
end

---Scroll documentation window.
mapping.scroll_docs = function(delta)
  return function(fallback)
    if not require('cmp').scroll_docs(delta) then
      fallback()
    end
  end
end

---Select next completion item.
mapping.select_next_item = function(option)
  return function(fallback)
    if not require('cmp').select_next_item(option) then
      local release = require('cmp').core:suspend()
      fallback()
      vim.schedule(release)
    end
  end
end

---Select prev completion item.
mapping.select_prev_item = function(option)
  return function(fallback)
    if not require('cmp').select_prev_item(option) then
      local release = require('cmp').core:suspend()
      fallback()
      vim.schedule(release)
    end
  end
end

---Confirm selection
mapping.confirm = function(option)
  return function(fallback)
    if not require('cmp').confirm(option) then
      fallback()
    end
  end
end

return mapping

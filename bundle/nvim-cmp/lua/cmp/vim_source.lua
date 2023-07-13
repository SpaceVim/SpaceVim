local misc = require('cmp.utils.misc')

local vim_source = {}

---@param id integer
---@param args any[]
vim_source.on_callback = function(id, args)
  if vim_source.to_callback.callbacks[id] then
    vim_source.to_callback.callbacks[id](unpack(args))
  end
end

---@param callback function
---@return integer
vim_source.to_callback = setmetatable({
  callbacks = {},
}, {
  __call = function(self, callback)
    local id = misc.id('cmp.vim_source.to_callback')
    self.callbacks[id] = function(...)
      callback(...)
      self.callbacks[id] = nil
    end
    return id
  end,
})

---Convert to serializable args.
---@param args any[]
vim_source.to_args = function(args)
  for i, arg in ipairs(args) do
    if type(arg) == 'function' then
      args[i] = vim_source.to_callback(arg)
    end
  end
  return args
end

---@param bridge_id integer
---@param methods string[]
vim_source.new = function(bridge_id, methods)
  local self = {}
  for _, method in ipairs(methods) do
    self[method] = (function(m)
      return function(_, ...)
        return vim.fn['cmp#_method'](bridge_id, m, vim_source.to_args({ ... }))
      end
    end)(method)
  end
  return self
end

return vim_source

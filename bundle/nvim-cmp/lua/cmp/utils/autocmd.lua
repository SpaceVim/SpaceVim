local debug = require('cmp.utils.debug')

local autocmd = {}

autocmd.events = {}

---Subscribe autocmd
---@param event string
---@param callback function
---@return function
autocmd.subscribe = function(event, callback)
  autocmd.events[event] = autocmd.events[event] or {}
  table.insert(autocmd.events[event], callback)
  return function()
    for i, callback_ in ipairs(autocmd.events[event]) do
      if callback_ == callback then
        table.remove(autocmd.events[event], i)
        break
      end
    end
  end
end

---Emit autocmd
---@param event string
autocmd.emit = function(event)
  debug.log(' ')
  debug.log(string.format('>>> %s', event))
  autocmd.events[event] = autocmd.events[event] or {}
  for _, callback in ipairs(autocmd.events[event]) do
    callback()
  end
end

return autocmd

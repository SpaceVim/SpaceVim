local debug = require('cmp.utils.debug')

local autocmd = {}

autocmd.group = vim.api.nvim_create_augroup('___cmp___', { clear = true })

autocmd.events = {}

---Subscribe autocmd
---@param events string|string[]
---@param callback function
---@return function
autocmd.subscribe = function(events, callback)
  events = type(events) == 'string' and { events } or events

  for _, event in ipairs(events) do
    if not autocmd.events[event] then
      autocmd.events[event] = {}
      vim.api.nvim_create_autocmd(event, {
        desc = ('nvim-cmp: autocmd: %s'):format(event),
        group = autocmd.group,
        callback = function()
          autocmd.emit(event)
        end,
      })
    end
    table.insert(autocmd.events[event], callback)
  end

  return function()
    for _, event in ipairs(events) do
      for i, callback_ in ipairs(autocmd.events[event]) do
        if callback_ == callback then
          table.remove(autocmd.events[event], i)
          break
        end
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

local keymap = require('cmp.utils.keymap')
local misc = require('cmp.utils.misc')

local feedkeys = {}

feedkeys.call = setmetatable({
  callbacks = {},
}, {
  __call = function(self, keys, mode, callback)
    local is_insert = string.match(mode, 'i') ~= nil
    local is_immediate = string.match(mode, 'x') ~= nil

    local queue = {}
    if #keys > 0 then
      table.insert(queue, { keymap.t('<Cmd>setlocal lazyredraw<CR>'), 'n' })
      table.insert(queue, { keymap.t('<Cmd>setlocal textwidth=0<CR>'), 'n' })
      table.insert(queue, { keymap.t('<Cmd>setlocal backspace=2<CR>'), 'n' })
      table.insert(queue, { keys, string.gsub(mode, '[itx]', ''), true })
      table.insert(queue, { keymap.t('<Cmd>setlocal %slazyredraw<CR>'):format(vim.o.lazyredraw and '' or 'no'), 'n' })
      table.insert(queue, { keymap.t('<Cmd>setlocal textwidth=%s<CR>'):format(vim.bo.textwidth or 0), 'n' })
      table.insert(queue, { keymap.t('<Cmd>setlocal backspace=%s<CR>'):format(vim.go.backspace or 2), 'n' })
    end

    if callback then
      local id = misc.id('cmp.utils.feedkeys.call')
      self.callbacks[id] = callback
      table.insert(queue, { keymap.t('<Cmd>call v:lua.cmp.utils.feedkeys.call.run(%s)<CR>'):format(id), 'n', true })
    end

    if is_insert then
      for i = #queue, 1, -1 do
        vim.api.nvim_feedkeys(queue[i][1], queue[i][2] .. 'i', queue[i][3])
      end
    else
      for i = 1, #queue do
        vim.api.nvim_feedkeys(queue[i][1], queue[i][2], queue[i][3])
      end
    end

    if is_immediate then
      vim.api.nvim_feedkeys('', 'x', true)
    end
  end,
})
misc.set(_G, { 'cmp', 'utils', 'feedkeys', 'call', 'run' }, function(id)
  if feedkeys.call.callbacks[id] then
    feedkeys.call.callbacks[id]()
    feedkeys.call.callbacks[id] = nil
  end
  return ''
end)

return feedkeys

local keymap = require('cmp.utils.keymap')
local misc = require('cmp.utils.misc')

local feedkeys = {}

feedkeys.call = setmetatable({
  callbacks = {},
}, {
  __call = function(self, keys, mode, callback)
    if vim.fn.reg_recording() ~= '' then
      return feedkeys.call_macro(keys, mode, callback)
    end

    local is_insert = string.match(mode, 'i') ~= nil
    local is_immediate = string.match(mode, 'x') ~= nil

    local queue = {}
    if #keys > 0 then
      table.insert(queue, { keymap.t('<Cmd>set lazyredraw<CR>'), 'n' })
      table.insert(queue, { keymap.t('<Cmd>set textwidth=0<CR>'), 'n' })
      table.insert(queue, { keymap.t('<Cmd>set eventignore=all<CR>'), 'n' })
      table.insert(queue, { keys, string.gsub(mode, '[itx]', ''), true })
      table.insert(queue, { keymap.t('<Cmd>set %slazyredraw<CR>'):format(vim.o.lazyredraw and '' or 'no'), 'n' })
      table.insert(queue, { keymap.t('<Cmd>set textwidth=%s<CR>'):format(vim.bo.textwidth or 0), 'n' })
      table.insert(queue, { keymap.t('<Cmd>set eventignore=%s<CR>'):format(vim.o.eventignore or ''), 'n' })
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

feedkeys.call_macro = setmetatable({
  queue = {},
  current = nil,
  timer = vim.loop.new_timer(),
  running = false,
}, {
  __call = function(self, keys, mode, callback)
    local is_insert = string.match(mode, 'i') ~= nil
    table.insert(self.queue, is_insert and 1 or #self.queue + 1, {
      keys = keys,
      mode = mode,
      callback = callback,
    })

    if not self.running then
      self.running = true
      local consume
      consume = vim.schedule_wrap(function()
        if vim.fn.getchar(1) == 0 then
          if self.current then
            vim.cmd(('set backspace=%s'):format(self.current.backspace or ''))
            vim.cmd(('set eventignore=%s'):format(self.current.eventignore or ''))
            if self.current.callback then
              self.current.callback()
            end
            self.current = nil
          end

          local current = table.remove(self.queue, 1)
          if current then
            self.current = {
              keys = current.keys,
              callback = current.callback,
              backspace = vim.o.backspace,
              eventignore = vim.o.eventignore,
            }
            vim.api.nvim_feedkeys(keymap.t('<Cmd>set backspace=start<CR>'), 'n', true)
            vim.api.nvim_feedkeys(keymap.t('<Cmd>set eventignore=all<CR>'), 'n', true)
            vim.api.nvim_feedkeys(current.keys, string.gsub(current.mode, '[i]', ''), true) -- 'i' flag is manually resolved.
          end
        end

        if #self.queue ~= 0 or self.current then
          vim.defer_fn(consume, 1)
        else
          self.running = false
        end
      end)
      vim.defer_fn(consume, 1)
    end
  end,
})

return feedkeys

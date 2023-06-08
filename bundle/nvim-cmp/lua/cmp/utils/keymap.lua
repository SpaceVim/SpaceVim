local misc = require('cmp.utils.misc')
local buffer = require('cmp.utils.buffer')
local api = require('cmp.utils.api')

local keymap = {}

---Shortcut for nvim_replace_termcodes
---@param keys string
---@return string
keymap.t = function(keys)
  return (string.gsub(keys, '(<[A-Za-z0-9\\%-%[%]%^@]->)', function(match)
    return vim.api.nvim_eval(string.format([["\%s"]], match))
  end))
end

---Normalize key sequence.
---@param keys string
---@return string
keymap.normalize = function(keys)
  local normalize_buf = buffer.ensure('cmp.util.keymap.normalize')
  vim.api.nvim_buf_set_keymap(normalize_buf, 't', keys, '<Plug>(cmp.utils.keymap.normalize)', {})
  for _, map in ipairs(vim.api.nvim_buf_get_keymap(normalize_buf, 't')) do
    if keymap.t(map.rhs) == keymap.t('<Plug>(cmp.utils.keymap.normalize)') then
      vim.api.nvim_buf_del_keymap(normalize_buf, 't', keys)
      return map.lhs
    end
  end
  vim.api.nvim_buf_del_keymap(normalize_buf, 't', keys)
  vim.api.nvim_buf_delete(normalize_buf, {})
  return keys
end

---Return vim notation keymapping (simple conversion).
---@param s string
---@return string
keymap.to_keymap = setmetatable({
  ['<CR>'] = { '\n', '\r', '\r\n' },
  ['<Tab>'] = { '\t' },
  ['<BSlash>'] = { '\\' },
  ['<Bar>'] = { '|' },
  ['<Space>'] = { ' ' },
}, {
  __call = function(self, s)
    return string.gsub(s, '.', function(c)
      for key, chars in pairs(self) do
        if vim.tbl_contains(chars, c) then
          return key
        end
      end
      return c
    end)
  end,
})

---Mode safe break undo
keymap.undobreak = function()
  if not api.is_insert_mode() then
    return ''
  end
  return keymap.t('<C-g>u')
end

---Mode safe join undo
keymap.undojoin = function()
  if not api.is_insert_mode() then
    return ''
  end
  return keymap.t('<C-g>U')
end

---Create backspace keys.
---@param count string|integer
---@return string
keymap.backspace = function(count)
  if type(count) == 'string' then
    count = vim.fn.strchars(count, true)
  end
  if count <= 0 then
    return ''
  end
  local keys = {}
  table.insert(keys, keymap.t(string.rep('<BS>', count)))
  return table.concat(keys, '')
end

---Create delete keys.
---@param count string|integer
---@return string
keymap.delete = function(count)
  if type(count) == 'string' then
    count = vim.fn.strchars(count, true)
  end
  if count <= 0 then
    return ''
  end
  local keys = {}
  table.insert(keys, keymap.t(string.rep('<Del>', count)))
  return table.concat(keys, '')
end

---Update indentkeys.
---@param expr? string
---@return string
keymap.indentkeys = function(expr)
  return string.format(keymap.t('<Cmd>set indentkeys=%s<CR>'), expr and vim.fn.escape(expr, '| \t\\') or '')
end

---Return two key sequence are equal or not.
---@param a string
---@param b string
---@return boolean
keymap.equals = function(a, b)
  return keymap.normalize(a) == keymap.normalize(b)
end

---Register keypress handler.
keymap.listen = function(mode, lhs, callback)
  lhs = keymap.normalize(keymap.to_keymap(lhs))

  local existing = keymap.get_map(mode, lhs)
  if existing.desc == 'cmp.utils.keymap.set_map' then
    return
  end

  local bufnr = existing.buffer and vim.api.nvim_get_current_buf() or -1
  local fallback = keymap.fallback(bufnr, mode, existing)
  keymap.set_map(bufnr, mode, lhs, function()
    local ignore = false
    ignore = ignore or (mode == 'c' and vim.fn.getcmdtype() == '=')
    if ignore then
      fallback()
    else
      callback(lhs, misc.once(fallback))
    end
  end, {
    expr = false,
    noremap = true,
    silent = true,
  })
end

---Fallback
keymap.fallback = function(bufnr, mode, map)
  return function()
    if map.expr then
      local fallback_lhs = string.format('<Plug>(cmp.u.k.fallback_expr:%s)', map.lhs)
      keymap.set_map(bufnr, mode, fallback_lhs, function()
        return keymap.solve(bufnr, mode, map).keys
      end, {
        expr = true,
        noremap = map.noremap,
        script = map.script,
        nowait = map.nowait,
        silent = map.silent and mode ~= 'c',
        replace_keycodes = map.replace_keycodes,
      })
      vim.api.nvim_feedkeys(keymap.t(fallback_lhs), 'im', true)
    elseif map.callback then
      map.callback()
    else
      local solved = keymap.solve(bufnr, mode, map)
      vim.api.nvim_feedkeys(solved.keys, solved.mode, true)
    end
  end
end

---Solve
keymap.solve = function(bufnr, mode, map)
  local lhs = keymap.t(map.lhs)
  local rhs = keymap.t(map.rhs)
  if map.expr then
    if map.callback then
      rhs = map.callback()
    else
      rhs = vim.api.nvim_eval(keymap.t(map.rhs))
    end
  end

  if map.noremap then
    return { keys = rhs, mode = 'in' }
  end

  if string.find(rhs, lhs, 1, true) == 1 then
    local recursive = string.format('<SNR>0_(cmp.u.k.recursive:%s)', lhs)
    keymap.set_map(bufnr, mode, recursive, lhs, {
      noremap = true,
      script = true,
      nowait = map.nowait,
      silent = map.silent and mode ~= 'c',
      replace_keycodes = map.replace_keycodes,
    })
    return { keys = keymap.t(recursive) .. string.gsub(rhs, '^' .. vim.pesc(lhs), ''), mode = 'im' }
  end
  return { keys = rhs, mode = 'im' }
end

---Get map
---@param mode string
---@param lhs string
---@return table
keymap.get_map = function(mode, lhs)
  lhs = keymap.normalize(lhs)

  for _, map in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
    if keymap.equals(map.lhs, lhs) then
      return {
        lhs = map.lhs,
        rhs = map.rhs or '',
        expr = map.expr == 1,
        callback = map.callback,
        desc = map.desc,
        noremap = map.noremap == 1,
        script = map.script == 1,
        silent = map.silent == 1,
        nowait = map.nowait == 1,
        buffer = true,
        replace_keycodes = map.replace_keycodes == 1,
      }
    end
  end

  for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
    if keymap.equals(map.lhs, lhs) then
      return {
        lhs = map.lhs,
        rhs = map.rhs or '',
        expr = map.expr == 1,
        callback = map.callback,
        desc = map.desc,
        noremap = map.noremap == 1,
        script = map.script == 1,
        silent = map.silent == 1,
        nowait = map.nowait == 1,
        buffer = false,
        replace_keycodes = map.replace_keycodes == 1,
      }
    end
  end

  return {
    lhs = lhs,
    rhs = lhs,
    expr = false,
    callback = nil,
    noremap = true,
    script = false,
    silent = true,
    nowait = false,
    buffer = false,
    replace_keycodes = true,
  }
end

---Set keymapping
keymap.set_map = function(bufnr, mode, lhs, rhs, opts)
  if type(rhs) == 'function' then
    opts.callback = rhs
    rhs = ''
  end
  opts.desc = 'cmp.utils.keymap.set_map'

  if vim.fn.has('nvim-0.8') == 0 then
    opts.replace_keycodes = nil
  end

  if bufnr == -1 then
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  else
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end
end

return keymap

local misc = {}

---Create once callback
---@param callback function
---@return function
misc.once = function(callback)
  local done = false
  return function(...)
    if done then
      return
    end
    done = true
    callback(...)
  end
end

---Return concatenated list
---@param list1 any[]
---@param list2 any[]
---@return any[]
misc.concat = function(list1, list2)
  local new_list = {}
  for _, v in ipairs(list1) do
    table.insert(new_list, v)
  end
  for _, v in ipairs(list2) do
    table.insert(new_list, v)
  end
  return new_list
end

---Repeat values
---@generic T
---@param str_or_tbl T
---@param count integer
---@return T
misc.rep = function(str_or_tbl, count)
  if type(str_or_tbl) == 'string' then
    return string.rep(str_or_tbl, count)
  end
  local rep = {}
  for _ = 1, count do
    for _, v in ipairs(str_or_tbl) do
      table.insert(rep, v)
    end
  end
  return rep
end

---Return the valu is empty or not.
---@param v any
---@return boolean
misc.empty = function(v)
  if not v then
    return true
  end
  if v == vim.NIL then
    return true
  end
  if type(v) == 'string' and v == '' then
    return true
  end
  if type(v) == 'table' and vim.tbl_isempty(v) then
    return true
  end
  if type(v) == 'number' and v == 0 then
    return true
  end
  return false
end

---The symbol to remove key in misc.merge.
misc.none = vim.NIL

---Merge two tables recursively
---@generic T
---@param tbl1 T
---@param tbl2 T
---@return T
misc.merge = function(tbl1, tbl2)
  local is_dict1 = type(tbl1) == 'table' and (not vim.tbl_islist(tbl1) or vim.tbl_isempty(tbl1))
  local is_dict2 = type(tbl2) == 'table' and (not vim.tbl_islist(tbl2) or vim.tbl_isempty(tbl2))
  if is_dict1 and is_dict2 then
    local new_tbl = {}
    for k, v in pairs(tbl2) do
      if tbl1[k] ~= misc.none then
        new_tbl[k] = misc.merge(tbl1[k], v)
      end
    end
    for k, v in pairs(tbl1) do
      if tbl2[k] == nil then
        if v ~= misc.none then
          new_tbl[k] = misc.merge(v, {})
        else
          new_tbl[k] = nil
        end
      end
    end
    return new_tbl
  end

  if tbl1 == misc.none then
    return nil
  elseif tbl1 == nil then
    return misc.merge(tbl2, {})
  else
    return tbl1
  end
end

---Generate id for group name
misc.id = setmetatable({
  group = {},
}, {
  __call = function(_, group)
    misc.id.group[group] = misc.id.group[group] or 0
    misc.id.group[group] = misc.id.group[group] + 1
    return misc.id.group[group]
  end,
})

---Treat 1/0 as bool value
---@param v boolean|1|0
---@param def boolean
---@return boolean
misc.bool = function(v, def)
  if v == nil then
    return def
  end
  return v == true or v == 1
end

---Set value to deep object
---@param t table
---@param keys string[]
---@param v any
misc.set = function(t, keys, v)
  local c = t
  for i = 1, #keys - 1 do
    local key = keys[i]
    c[key] = c[key] or {}
    c = c[key]
  end
  c[keys[#keys]] = v
end

---Copy table
---@generic T
---@param tbl T
---@return T
misc.copy = function(tbl)
  if type(tbl) ~= 'table' then
    return tbl
  end

  if vim.tbl_islist(tbl) then
    local copy = {}
    for i, value in ipairs(tbl) do
      copy[i] = misc.copy(value)
    end
    return copy
  end

  local copy = {}
  for key, value in pairs(tbl) do
    copy[key] = misc.copy(value)
  end
  return copy
end

---Safe version of vim.str_utfindex
---@param text string
---@param vimindex integer|nil
---@return integer
misc.to_utfindex = function(text, vimindex)
  vimindex = vimindex or #text + 1
  return vim.str_utfindex(text, math.max(0, math.min(vimindex - 1, #text)))
end

---Safe version of vim.str_byteindex
---@param text string
---@param utfindex integer
---@return integer
misc.to_vimindex = function(text, utfindex)
  utfindex = utfindex or #text
  for i = utfindex, 1, -1 do
    local s, v = pcall(function()
      return vim.str_byteindex(text, i) + 1
    end)
    if s then
      return v
    end
  end
  return utfindex + 1
end

---Mark the function as deprecated
misc.deprecated = function(fn, msg)
  local printed = false
  return function(...)
    if not printed then
      print(msg)
      printed = true
    end
    return fn(...)
  end
end

--Redraw
misc.redraw = setmetatable({
  doing = false,
  force = false,
  -- We use `<Up><Down>` to redraw the screen. (Previously, We use <C-r><ESC>. it will remove the unmatches search history.)
  incsearch_redraw_keys = ' <BS>',
}, {
  __call = function(self, force)
    local termcode = vim.api.nvim_replace_termcodes(self.incsearch_redraw_keys, true, true, true)
    if vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype()) then
      if vim.o.incsearch then
        return vim.api.nvim_feedkeys(termcode, 'ni', true)
      end
    end

    if self.doing then
      return
    end
    self.doing = true
    self.force = not not force
    vim.schedule(function()
      if self.force then
        vim.cmd([[redraw!]])
      else
        vim.cmd([[redraw]])
      end
      self.doing = false
      self.force = false
    end)
  end,
})

return misc

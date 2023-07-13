local kit = {}

local is_thread = vim.is_thread()

---Create gabage collection detector.
---@param callback fun(...: any): any
---@return userdata
function kit.gc(callback)
  local gc = newproxy(true)
  if vim.is_thread() or os.getenv('NODE_ENV') == 'test' then
    getmetatable(gc).__gc = callback
  else
    getmetatable(gc).__gc = vim.schedule_wrap(callback)
  end
  return gc
end

---Bind arguments for function.
---@param fn fun(...: any): any
---@vararg any
---@return fun(...: any): any
function kit.bind(fn, ...)
  local args = { ... }
  return function(...)
    return fn(unpack(args), ...)
  end
end

---Safe version of vim.schedule.
---@param fn fun(...: any): any
function kit.safe_schedule(fn)
  if is_thread then
    fn()
  else
    vim.schedule(fn)
  end
end

---Safe version of vim.schedule_wrap.
---@param fn fun(...: any): any
function kit.safe_schedule_wrap(fn)
  if is_thread then
    return fn
  else
    return vim.schedule_wrap(fn)
  end
end

---Create unique id.
---@return integer
kit.unique_id = setmetatable({
  unique_id = 0,
}, {
  __call = function(self)
    self.unique_id = self.unique_id + 1
    return self.unique_id
  end,
})

---Merge two tables.
---@generic T
---NOTE: This doesn't merge array-like table.
---@param tbl1 T
---@param tbl2 T
---@return T
function kit.merge(tbl1, tbl2)
  local is_dict1 = kit.is_dict(tbl1)
  local is_dict2 = kit.is_dict(tbl2)
  if is_dict1 and is_dict2 then
    local new_tbl = {}
    for k, v in pairs(tbl2) do
      if tbl1[k] ~= vim.NIL then
        new_tbl[k] = kit.merge(tbl1[k], v)
      end
    end
    for k, v in pairs(tbl1) do
      if tbl2[k] == nil then
        if v ~= vim.NIL then
          new_tbl[k] = v
        else
          new_tbl[k] = nil
        end
      end
    end
    return new_tbl
  elseif is_dict1 and not is_dict2 then
    return kit.merge(tbl1, {})
  elseif not is_dict1 and is_dict2 then
    return kit.merge(tbl2, {})
  end

  if tbl1 == vim.NIL then
    return nil
  elseif tbl1 == nil then
    return tbl2
  else
    return tbl1
  end
end

---Recursive convert value via callback function.
---@param tbl table
---@param callback fun(value: any): any
---@return table
function kit.convert(tbl, callback)
  if kit.is_dict(tbl) then
    local new_tbl = {}
    for k, v in pairs(tbl) do
      new_tbl[k] = kit.convert(v, callback)
    end
    return new_tbl
  end
  return callback(tbl)
end

---Map array.
---@param array table
---@param fn fun(item: unknown, index: integer): unknown
---@return unknown[]
function kit.map(array, fn)
  local new_array = {}
  for i, item in ipairs(array) do
    table.insert(new_array, fn(item, i))
  end
  return new_array
end

---Concatenate two tables.
---NOTE: This doesn't concatenate dict-like table.
---@param tbl1 table
---@param tbl2 table
---@return table
function kit.concat(tbl1, tbl2)
  local new_tbl = {}
  for _, item in ipairs(tbl1) do
    table.insert(new_tbl, item)
  end
  for _, item in ipairs(tbl2) do
    table.insert(new_tbl, item)
  end
  return new_tbl
end

---The value to array.
---@param value any
---@return table
function kit.to_array(value)
  if type(value) == 'table' then
    if vim.tbl_islist(value) or vim.tbl_isempty(value) then
      return value
    end
  end
  return { value }
end

---Check the value is array.
---@param value any
---@return boolean
function kit.is_array(value)
  return not not (type(value) == 'table' and (vim.tbl_islist(value) or vim.tbl_isempty(value)))
end

---Check the value is dict.
---@param value any
---@return boolean
function kit.is_dict(value)
  return type(value) == 'table' and (not vim.tbl_islist(value) or vim.tbl_isempty(value))
end

---Reverse the array.
---@param array table
---@return table
function kit.reverse(array)
  if not kit.is_array(array) then
    error('[kit] specified value is not an array.')
  end

  local new_array = {}
  for i = #array, 1, -1 do
    table.insert(new_array, array[i])
  end
  return new_array
end

---@generic T
---@param value T?
---@param default T
function kit.default(value, default)
  if value == nil then
    return default
  end
  return value
end

---Get object path with default value.
---@generic T
---@param value table
---@param path integer|string|(string|integer)[]
---@param default? T
---@return T
function kit.get(value, path, default)
  local result = value
  for _, key in ipairs(kit.to_array(path)) do
    if type(result) == 'table' then
      result = result[key]
    else
      return default
    end
  end
  return result or default
end

return kit

local binary = {}

---Insert item to list to ordered index
---@param list any[]
---@param item any
---@param func fun(a: any, b: any): 1|-1|0
binary.insort = function(list, item, func)
  table.insert(list, binary.search(list, item, func), item)
end

---Search suitable index from list
---@param list any[]
---@param item any
---@param func fun(a: any, b: any): 1|-1|0
---@return integer
binary.search = function(list, item, func)
  local s = 1
  local e = #list
  while s <= e do
    local idx = math.floor((e + s) / 2)
    local diff = func(item, list[idx])
    if diff > 0 then
      s = idx + 1
    elseif diff < 0 then
      e = idx - 1
    else
      return idx + 1
    end
  end
  return s
end

return binary

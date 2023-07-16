local M = {}

local function parse_input(char)
  if char == 27 then
    return ''
  else
    return char
  end
end

local function next_item(list, item)
  local id = vim.fn.index(list, item)
  if id == #list then
    return list[1]
  else
    return list[id]
  end
end


local function previous_item(list, item)
  local id = vim.fn.index(list, item)
  if id == 0 then
    return list[#list]
  else
    return list[id]
  end
end

local function parse_items(items)
  local is = {}
  for _, item in pairs(items) do
    local id = vim.fn.index(items, item) + 1
    is[id] = item
    is[id][1] = '(' .. id .. ')' .. item[1]
  end
  return is
end

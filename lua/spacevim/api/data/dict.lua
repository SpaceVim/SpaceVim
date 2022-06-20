local M = {}


function M.entrys(d)
    
end

function M.pick(d, keys)
    local new_d = {}
    for key, value in pairs(d) do
    end
    return new_d
end


---
-- @function: 打印table的内容，递归
-- @param: tbl 要打印的table
-- @param: level 递归的层数，默认不用传值进来
-- @param: filteDefault 是否过滤打印构造函数，默认为是
-- @return: return
function M.print( tbl , level, filteDefault)
  local msg = ""
  filteDefault = filteDefault or true
  level = level or 1
  local indent_str = ""
  for i = 1, level do
    indent_str = indent_str.."  "
  end

  print(indent_str .. "{")
  for k,v in pairs(tbl) do
    if filteDefault then
      if k ~= "_class_type" and k ~= "DeleteMe" then
        local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
        print(item_str)
        if type(v) == "table" then
          PrintTable(v, level + 1)
        end
      end
    else
      local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
      print(item_str)
      if type(v) == "table" then
        PrintTable(v, level + 1)
      end
    end
  end
  print(indent_str .. "}")
end


function M.make(keys, values, ...)
    local dict = {}
    local arg = {...}
    local fill = arg[1] or 0
    for i = 1, #keys do
        local key = tostring(keys[i])
        if key == '' then return {} end
        dict[key] = values[i] or fill
    end
    return dict
end

function M.swap(d)
    
end

function M.make_index(list, ...)
    
end




return M



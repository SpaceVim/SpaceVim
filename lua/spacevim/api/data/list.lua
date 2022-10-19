-- @idea add list lua api
-- pop({list})
local list = {}


function list.pop(l)
  return table.remove(l)
end


return list



local str = {}


function str.trim(str)
    return str:match( "^%s*(.-)%s*$" )
end


function str.fill(str, length, ...)
    if string.len(str) > length then
    end
    
end


return str

-- @todo add lua string api


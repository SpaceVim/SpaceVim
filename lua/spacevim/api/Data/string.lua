local str = {}


function str.trim(str)
    return str:match( "^%s*(.-)%s*$" )
end


return str

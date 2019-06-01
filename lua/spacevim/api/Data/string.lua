local str = {}


function str.trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%")
end


return str

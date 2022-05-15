local format = function (str)
  if type(str) ~= "string" then return nil end
  local result = "Binary string length; " .. tostring(#str) .. " bytes\n"
  local i = 1
  local hex = ""
  local chr = ""
  while i <= #str do
    local byte = str:byte(i)
    hex = string.format("%s%2x ", hex, byte)
    if byte < 32 then byte = string.byte(".") end
    chr = chr .. string.char(byte)
    if math.floor(i/16) == i/16 or i == #str then
      -- reached end of line
      hex = hex .. string.rep(" ", 16 * 3 - #hex)
      chr = chr .. string.rep(" ", 16 - #chr)

      result = result .. hex:sub(1, 8 * 3) .. "  " .. hex:sub(8*3+1, -1) .. " " .. chr:sub(1,8) .. " " .. chr:sub(9,-1) .. "\n"

      hex = ""
      chr = ""
    end
    i = i + 1
  end
  return result
end

return format


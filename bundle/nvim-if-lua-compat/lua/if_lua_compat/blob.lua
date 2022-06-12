--- Wrapper class to interact with blobs
--- @class Blob

local Blob

--- @param str string
--- @param index number
--- @return number, number
local function str_iter(str, index)
    if index == #str then return end
    index = index + 1
    return index, str:sub(index, index):byte()
end

--- @param bytes_str string|number
--- @return function, string, number
local function str_to_bytes(bytes_str)
    if type(bytes_str) == 'number' then bytes_str = tostring(bytes_str) end
    if type(bytes_str) ~= 'string' then error('string expected, got ' .. type(bytes_str)) end
    return str_iter, bytes_str, 0
end

local blob_methods = {
    --- @param self Blob
    --- @param bytes_str string|number
    add = function(self, bytes_str)
        local is_empty = not self[0]
        for _, byte in str_to_bytes(bytes_str) do
            if is_empty then
                table.insert(self, 0, byte)
                is_empty = false
            else
                table.insert(self, byte)
            end
        end
    end,
}

local blob_mt = {
    _vim_type = 'blob',
    __index = blob_methods,
    __newindex = function(blob, key, value)
        if type(key) == 'number' then rawset(blob, key, value) end
        return
    end,
    __len = function(blob) return rawlen(blob) + 1 end,
}

--- @param bytes_str string|number
--- @return Blob
function Blob(bytes_str)
    local blob = {}
    if bytes_str ~= nil then
        for idx, byte in str_to_bytes(bytes_str) do
            blob[idx - 1] = byte
        end
    end
    return setmetatable(blob, blob_mt)
end

return Blob

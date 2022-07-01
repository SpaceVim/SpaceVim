local validate = vim.validate

--- Wrapper class to interact with vim dictionaries
--- @class Dict

local valid_key_types = {
    string = true,
    number = true,
}

local dict_mt = {
    __index = function(dict, key)
        if not valid_key_types[type(key)] then
            return error(("bad argument #2 to '__index' (string expected, got %s)"):format(type(key)))
        end
        return rawget(dict, tostring(key))
    end,
    __newindex = function(dict, key, value)
        if not valid_key_types[type(key)] then
            return error(("bad argument #2 to '__newindex' (string expected, got %s)"):format(type(key)))
        end
        rawset(dict, tostring(key), value)
    end,
    __call = pairs,
    __len = vim.tbl_count,
    _vim_type = 'dict',
}

--- @param tbl table
--- @return Dict
function Dict(tbl)
    validate {
        tbl = {tbl, 'table', true}
    }

    local dict = vim.empty_dict()
    if tbl then
        for k, v in pairs(tbl) do
            if not valid_key_types[type(k)] then return nil end
            dict[tostring(k)] = v
        end
    end
    return setmetatable(dict, dict_mt)
end

return Dict

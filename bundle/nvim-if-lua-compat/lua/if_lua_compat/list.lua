local validate = vim.validate

--- Wrapper class to interact with vim lists
--- @class List

local list_methods = {
    --- @param self List
    --- @param item any
    add = table.insert,

    --- @param self     List
    --- @param item     any
    --- @param position number
    insert = function(self, item, position)
        if position then
            if position > #self then position = #self end
            if position < 0 then position = 0 end
            table.insert(self, position + 1, item)
        else
            table.insert(self, 1, item)
        end
    end,
}

local list_mt = {
    __index = list_methods,
    __newindex = function(list, key, value)
        if type(key) == 'number' then rawset(list, key, value) end
    end,
    __call = function(list)
        local index = 0
        local length = #list
        local function list_iter()
            if index == length then return end
            index = index + 1
            return list[index]
        end
        return list_iter, list, nil
    end,
    _vim_type = 'list',
}

--- @param tbl table
--- @return List
function List(tbl)
    validate {
        tbl = {tbl, 'table', true}
    }

    local list = {}
    if tbl then
        for _, v in ipairs(tbl) do
            table.insert(list, v)
        end
    end
    return setmetatable(list, list_mt)
end

return List

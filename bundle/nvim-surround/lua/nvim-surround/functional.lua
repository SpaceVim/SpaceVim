local M = {}

-- Converts singular elements to lists of one element; does nothing to lists.
---@generic T
---@param t T|T[]|nil The input element.
---@return T[]|nil @The input wrapped in a list, if necessary.
M.to_list = function(t)
    if not t or type(t) == "table" then
        return t
    end
    return { t }
end

return M

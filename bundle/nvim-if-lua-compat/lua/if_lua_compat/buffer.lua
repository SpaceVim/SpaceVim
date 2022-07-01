local api = vim.api
local fn = vim.fn

--- Wrapper to interact with buffers
--- @class Buffer

local Buffer

local buf_methods = {
    --- @param self    Buffer
    --- @param newline string
    --- @param pos     number
    insert = function(self, newline, pos)
        api.nvim_buf_set_lines(self._bufnr, pos or -1, pos or -1, false, {newline})
    end,

    --- @param self Buffer
    --- @return boolean
    isvalid = function(self)
        return api.nvim_buf_is_valid(self._bufnr)
    end,

    --- @param self Buffer
    --- @return Buffer|nil
    next = function(self)
        local bufnr = self._bufnr
        local buffers = api.nvim_list_bufs()
        local next_buf
        for k, v in ipairs(buffers) do
            if v == bufnr then
                next_buf = k + 1
                break
            end
        end
        if next_buf and buffers[next_buf] then
            return Buffer(buffers[next_buf])
        end
        return nil
    end,

    --- @param self Buffer
    --- @return Buffer|nil
    previous = function(self)
        local bufnr = self._bufnr
        local buffers = api.nvim_list_bufs()
        local prev_buf
        for k, v in ipairs(buffers) do
            if v == bufnr then
                prev_buf = k - 1
                break
            end
        end
        if prev_buf and buffers[prev_buf] then
            return Buffer(buffers[prev_buf])
        end
        return nil
    end,
}

local buf_getters = {
    --- @param bufnr number
    --- @return number
    number = function(bufnr)
        return bufnr
    end,

    --- @param bufnr number
    --- @return string
    fname = api.nvim_buf_get_name,

    --- @param bufnr number
    --- @return string
    name = fn.bufname,
}

local buf_mt = {
    _vim_type = 'buffer',
    __index = function(tbl, key)
        if type(key) == 'number' then
            return api.nvim_buf_get_lines(tbl._bufnr, key - 1, key, false)[1]
        end
        if buf_methods[key] then return buf_methods[key] end
        if buf_getters[key] then return buf_getters[key](tbl._bufnr) end
    end,
    __newindex = function() return end,
    __call = function(tbl)
        api.nvim_set_current_buf(tbl._bufnr)
    end,
    -- Only works with Lua 5.2+ or LuaJIT built with 5.2 extensions
    __len = function(tbl)
        return api.nvim_buf_line_count(tbl._bufnr)
    end,
}

--- @param arg ?any
--- @return Buffer|nil
function Buffer(arg)
    local bufnr

    if not arg then
        bufnr = api.nvim_get_current_buf()
    elseif type(arg) == 'string' then
        bufnr = fn.bufnr(arg)
        if bufnr == -1 then return nil end
    elseif type(arg) == 'number' then
        if not api.nvim_buf_is_valid(arg) then return nil end
        bufnr = arg
    else
        bufnr = api.nvim_list_bufs()[1]
    end

    return setmetatable({_bufnr = bufnr}, buf_mt)
end

return Buffer

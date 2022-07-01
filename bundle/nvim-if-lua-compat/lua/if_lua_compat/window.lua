local api = vim.api
local Buffer = require('if_lua_compat.buffer')

--- Wrapper to interact with windows
--- @class Window

local Window

local win_methods = {
    --- @param self Window
    --- @return boolean
    isvalid = function(self)
        return api.nvim_win_is_valid(self._winnr)
    end,

    --- @param self Window
    --- @return Window|nil
    next = function(self)
        local winnr = self._winnr
        local windows = api.nvim_tabpage_list_wins(api.nvim_win_get_tabpage(winnr))
        local next_win
        for k, v in ipairs(windows) do
            if v == winnr then
                next_win = k + 1
                break
            end
        end
        if next_win and windows[next_win] then
            return Window(next_win)
        end
        return nil
    end,

    --- @param self Window
    --- @return Window|nil
    previous = function(self)
        local winnr = self._winnr
        local windows = api.nvim_tabpage_list_wins(api.nvim_win_get_tabpage(winnr))
        local prev_win
        for k, v in ipairs(windows) do
            if v == winnr then
                prev_win = k - 1
                break
            end
        end
        if prev_win and windows[prev_win] then
            return Window(prev_win)
        end
        return nil
    end,
}

local win_getters = {
    --- @param winnr number
    --- @return Buffer
    buffer = function(winnr)
        return Buffer(api.nvim_win_get_buf(winnr))
    end,

    --- @param winnr number
    --- @return number
    line = function(winnr)
        return api.nvim_win_get_cursor(winnr)[1]
    end,

    --- @param winnr number
    --- @return number
    col = function(winnr)
        return api.nvim_win_get_cursor(winnr)[2] + 1
    end,

    --- @param winnr number
    --- @return number
    width = api.nvim_win_get_width,

    --- @param winnr number
    --- @return number
    height = api.nvim_win_get_height,
}

local win_setters = {
    --- @param winnr number
    --- @param line  number
    line = function(winnr, line)
        api.nvim_win_set_cursor(winnr, {line, 0})
    end,

    --- @param winnr number
    --- @param col   number
    col = function(winnr, col)
        api.nvim_win_set_cursor(winnr, {api.nvim_win_get_cursor(winnr)[1], col - 1})
    end,

    --- @param winnr number
    --- @param width number
    width = api.nvim_win_set_width,

    --- @param winnr  number
    --- @param height number
    height = api.nvim_win_set_height,
}

local win_mt = {
    _vim_type = 'window',
    __index = function(tbl, key)
        if win_methods[key] then return win_methods[key] end
        if win_getters[key] then return win_getters[key](tbl._winnr) end
    end,
    __newindex = function(tbl, key, value)
        if win_setters[key] then return win_setters[key](tbl._winnr, value)
        else error(('Invalid window property: %s'):format(key))
        end
    end,
    __call = function(tbl)
        api.nvim_set_current_win(tbl._winnr)
    end,
}

--- @param arg ?any
--- @return Window|nil
function Window(arg)
    local windows = api.nvim_tabpage_list_wins(0)
    local winnr

    if not arg then
        winnr = api.nvim_get_current_win()
    elseif type(arg) == 'number' then
        if not windows[arg] then return nil end
        winnr = windows[arg]
    else
        winnr = windows[1]
    end

    return setmetatable({_winnr = winnr}, win_mt)
end

return Window

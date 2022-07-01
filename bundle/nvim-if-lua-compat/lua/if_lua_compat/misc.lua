local api = vim.api
local fn = vim.fn
local Buffer = require('if_lua_compat.buffer')

local valid_fname_types = {
    number = true,
    string = true,
}

--- @param fname ?any
--- @return Buffer
local function vim_open(fname)
    fname = valid_fname_types[type(fname)] and tostring(fname) or nil

    local bufnr = fn.bufadd(fname or '')
    api.nvim_buf_set_option(bufnr, 'buflisted', true)

    return Buffer(bufnr)
end

--- @param object any
--- @return string
local function vim_type(object)
    local mt = getmetatable(object) or {}
    return mt._vim_type or type(object)
end

local function vim_beep()
    local belloff = api.nvim_get_option('belloff')
    if belloff:match('all') or belloff:match('lang') then return end
    io.stdout:write('\a')
end

--- Wrapper class to interact with vim funcrefs
--- @class Funcref

local funcref_mt = {
    _vim_type = 'funcref',
    __call = function(tbl, ...) return vim.call(tbl._funcname, ...) end,
    -- Only works with Lua 5.2+ or LuaJIT built with 5.2 extensions
    __len = function(tbl) return tbl._funcname end,
}

--- @param funcname string
--- @return Funcref
local function vim_funcref(funcname)
    if type(funcname) ~= 'string' then
        return error(("Bad argument #1 to 'funcref' (string expected, got %s)"):format(type(funcname)))
    end
    return setmetatable({_funcname = funcname}, funcref_mt)
end

return {
    open = vim_open,
    type = vim_type,
    beep = vim_beep,
    funcref = vim_funcref,
}

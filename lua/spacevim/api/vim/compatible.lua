local M = {}

local system = require('spacevim.api').import('system')
local fn = nil
local has = nil

if vim.fn == nil then
    fn = require('spacevim').fn
else
    fn = vim.fn
end

if vim.api == nil then
    has = require('spacevim').has
else
    if vim.fn ~= nil then
        has = vim.fn.has
    else
        has = require('spacevim').has
    end
end

local has_cache = {}

function M.has(feature)
    if has_cache[feature] ~= nil then
        return has_cache[feature]
    end
end

if has('patch-7.4.279') then
    function M.globpath(dir, expr)
        return fn.globpath(dir, expr, 1, 1)
    end
else
    function M.globpath(dir, expr)
        return fn.split(fn.globpath(dir, expr), "\n")
    end
end

return M

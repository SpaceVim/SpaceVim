--=============================================================================
-- opt.lua --- The global option of spacevim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local sp = require('spacevim')

local mt = {
    -- this is call when we use opt.xxxx = xxx
    __newindex = function(table, key, value)
        if vim.g ~= nil then
            vim.g['spacevim_' .. key] = value
        else
        end

    end,
    -- this is call when we use opt.xxxx
    __index = function(table, key)
        if vim.g ~= nil then
            return vim.g['spacevim_' .. key] or nil 
        else
            return sp.eval('get(g:, "spacevim_' .. key .. '", v:null)')
        end
    end
}
setmetatable(M, mt)

return M

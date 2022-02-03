--=============================================================================
-- layer.lua --- spacevim layer module
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}
local sp = require('spacevim')

-- local mt = {
    -- __newindex = function(layer, layer_name, layer_obj)
        -- rawset(layer, layer_name, layer_obj)
    -- end,
    -- __index = function(layer, layer_name)
        -- if vim.g ~= nil then
            -- return vim.g['spacevim_' .. key] or nil
        -- else
            -- return sp.eval('get(g:, "spacevim_' .. key .. '", v:null)')
        -- end
    -- end
-- }
-- setmetatable(M, mt)

function M.isLoaded(layer)
    return sp.call('SpaceVim#layers#isLoaded', layer) == 1
end


return M

--=============================================================================
-- api.lua --- lua api plugin
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}


-- local logger = require('spacevim.logger')

function M.import(name)
    local ok, rst = pcall(require, 'spacevim.api.' .. name)
    if ok then
        return rst
    end
end

return M

--=============================================================================
-- api.lua --- lua api plugin
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}


-- local logger = require('spacevim.logger')

function M.import(name)
    local p = 'spacevim.api.' .. name
    local ok, rst = pcall(require, p)
    if ok then
        package.loaded[p] = nil
        return rst
    else
        return nil
    end
end

return M

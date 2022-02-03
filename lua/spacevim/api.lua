--=============================================================================
-- api.lua --- lua api plugin
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.import(name)
 return require('spacevim.api.' .. name)   
end

return M

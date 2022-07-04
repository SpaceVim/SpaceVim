--=============================================================================
-- regex.lua --- use vim regex in lua
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


-- in viml you can use =~/=~#/=~？


local M = {}

M.__cmp = require('spacevim.api').import('vim.compatible')

function M.equal(a, b, ...)
    local argv = {...}
    local ignore = argv[1] or false
    if M.__cmp.fn.matchstr(a, b) == '' then return false else return true end
end

return M

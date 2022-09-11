--=============================================================================
-- default.lua --- default option
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}

function M.options()

    vim.o.laststatus = 2

    vim.o.showcmd = false

    vim.o.autoindent = true

    vim.o.linebreak = true
    
end

return M

--=============================================================================
-- command.lua --- Commands for spacevim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local command = require('spacevim.api').import('vim.command')

function M.init()
    command.defined({
        name = 'SPUpdate',
        vim_function = 'SpaceVim#plugins#update'
    })
    
end

return M

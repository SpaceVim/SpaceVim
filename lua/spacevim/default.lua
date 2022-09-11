--=============================================================================
-- default.lua --- default option
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}

function M.options()

    if vim.fn.has('gui_running') == 1 then
        vim.opt.guioptions:remove(
        {
            'm', -- hide menu bar
            'T', -- hide toolbar
            'L', -- hide left-hand scrollbar
            'r', -- hide right-hand scrollbar
            'b', -- hide bottom scrollbar
            'e', -- hide tab
        }
        )
    end

    vim.o.laststatus = 2

    vim.o.showcmd = false

    vim.o.autoindent = true

    vim.o.linebreak = true
    
end

return M

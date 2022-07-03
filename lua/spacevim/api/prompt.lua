--=============================================================================
-- prompt.lua --- prompt api for spacevim
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

M.__cmp = require('spacevim.api').import('vim.compatible')
M.__vim = require('spacevim.api').import('vim')


M._keys = {
    close = "<Esc>"
}

M._prompt = {
    mpt = '==>',
    begin = '',
    cursor = '',
    ['end'] = '',
}

M._function_key = {}

M._quit = true

M._handle_fly = ''

M._onclose = ''

M._oninputpro = ''


function M._build_prompt()
    local ident = M.__cmp.fn['repeat'](' ', M.__cmp.win_screenpos(0)[2] - 1)
end

function M._clear_prompt()
    M._prompt = {
        mpt = M._prompt.mpt,
        begin = '',
        cursor = '',
        ['end'] = ''
    }
end


return M

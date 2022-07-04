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

function M.open()
    M._quit = false
    M._build_prompt()
    if M.__cmp.fn.empty(M._prompt.begin) == 0 then
        M._handle_input(M._prompt.begin)
    else
        M._handle_input()
    end
end

function M._c_r_mode_off(timer)
    M._c_r_mode = false
end

function M._handle_input(...)
    local argv = {...}
    local begin = argv[1] or ''
    if M.__cmp.fn.empty(begin) == 0 then
        if M.__cmp.fn['type'](M._oninputpro) == 2 then
        end
        if M.__cmp.fn['type'](M._handle_fly) == 2 then
        end
        M._build_prompt()
    end
end


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

function M.close()
    
end


return M

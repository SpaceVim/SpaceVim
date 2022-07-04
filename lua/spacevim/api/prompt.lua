--=============================================================================
-- prompt.lua --- prompt api for spacevim
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

M.__cmp = require('spacevim.api').import('vim.compatible')


M._keys = {
    close = "<Esc>"
}

M._prompt = {
    mpt = '==>',
    cursor_begin = '',
    cursor_char = '',
    cursor_end = '',
}

M._function_key = {}

M._quit = true

M._handle_fly = ''

M._onclose = ''

M._oninputpro = ''

function M.open()
    M._quit = false
    M._build_prompt()
    if M.__cmp.fn.empty(M._prompt.cursor_begin) == 0 then
        M._handle_input(M._prompt.cursor_begin)
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
    if begin == '' then
        if type(M._oninputpro) == 'function' then
            M._oninputpro()
        end
        if type(M._handle_fly) == 'function' then
            M._handle_fly(M._prompt.cursor_begin
            .. M._prompt.cursor_char
            .. M._prompt.cursor_end)
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
        cursor_begin = '',
        cursor_char = '',
        cursor_end = ''
    }
end

function M.close()

end


return M

--=============================================================================
-- iedit.lua --- multiple cursor for spacevim in lua
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local index = -1
local cursor_col = -1
local mode = ''
local hi_id = ''
local Operator = ''
local iedit_cursor_hi_info = {}

local hi = require('spacevim.api').import('vim.highlight')
local str = require('spacevim.api').import('data.string')
local cmp = require('spacevim.api').import('vim.compatible')
local v = require('spacevim.api').import('vim')

local logger = require('spacevim.logger').derive('iedit')

local cursor_stack = {}

local iedit_hi_info = {
    {
        name = 'IeditPurpleBold',
        guibg = '#3c3836',
        guifg = '#d3869b',
        ctermbg = '',
        ctermfg = 175,
        bold = 1,
    },{
        name = 'IeditBlueBold',
        guibg = '#3c3836',
        guifg = '#83a598',
        ctermbg = '',
        ctermfg = 109,
        bold = 1,
    },{
        name = 'IeditInactive',
        guibg = '#3c3836',
        guifg = '#abb2bf',
        ctermbg = '',
        ctermfg = 145,
        bold = 1,
    },
}

local function highlight_cursor()
    hi.hi(iedit_cursor_hi_info)
    for _,i in vim.fn.range(1, #cursor_stack) do
        if cursor_stack[i].active then
            if i == index then
                vim.fn.matchaddpos('IeditPurpleBold',{
                    {
                        cursor_stack[i].lnum,
                        cursor_stack[i].col,
                        cursor_stack[i].len,
                    }
                })
            else
                vim.fn.matchaddpos('IeditBlueBold',{
                    {
                        cursor_stack[i].lnum,
                        cursor_stack[i].col,
                        cursor_stack[i].len,
                    }
                })
            end
            vim.fn.matchadd('SpaceVimGuideCursor', [[\%]]
            .. cursor_stack[i].lnum
            .. [[l\%]]
            .. (cursor_stack[i].col + vim.fn.len(cursor_stack[i].begin))
            .. 'c',
            99999)
        else
            vim.fn.matchaddpos('IeditInactive',{
                {
                    cursor_stack[i].lnum,
                    cursor_stack[i].col,
                    cursor_stack[i].len,
                }
            })
        end
    end
end

local function remove_cursor_highlight()
    vim.fn.clearmatches()
end

local function handle(mode, char)
    if mode == 'n' and Operator == 'f' then
        handle_f_char(char)
    elseif mode == 'n' then
        handle_normal(char)
    elseif mode == 'r' and Operator == 'r' then
        handle_register(char)
    elseif mode == 'i' then
        handle_insert(char)
    end
end

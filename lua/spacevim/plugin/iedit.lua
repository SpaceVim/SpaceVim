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

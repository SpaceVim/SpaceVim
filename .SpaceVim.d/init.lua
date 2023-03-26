--=============================================================================
-- init.lua --- demo
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local layer = require('spacevim.layer')
local opt = require('spacevim.opt')

opt.colorscheme = 'one'

layer.load('lang#java', {
    format_on_save = false
})

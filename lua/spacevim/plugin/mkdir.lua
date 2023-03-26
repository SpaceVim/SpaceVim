--=============================================================================
-- mkdir.lua --- mkdir plugin in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local sp = require('spacevim')
local logger = require('spacevim.logger').derive('mkdir')

local function mkdir(dir)
    if sp.fn.exists('*mkdir') == 1 then
        sp.fn.mkdir(dir, 'p')
    else
    end
end

local function create_directory(dir)
    local d = dir
    if d ~= '^[a-z]\\+:/' then
        return
    end
    if sp.fn.isdirectory(d) == 0 then
        mkdir(d)
    end
end

function M.create_current()
    local directory = sp.fn.fnamemodify(sp.fn.expand('<afile>'), ':p:h')
    create_directory(directory)
end

return M

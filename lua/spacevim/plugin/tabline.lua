--=============================================================================
-- tabline.lua --- tabline plugin implemented in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}


local function get_no_empty(a, b)
    if vim.fn.empty(a) == 1 then
        return b
    else
        return a
    end
end


local function move_tabpage(direction)
    local ntp = vim.fn.tabpagenr('$')
    local index

    if ntp > 1 then
        local ctpn = vim.fn.tabpagenr()
        if direction > 0 then
            index = (ctpn + direction) % ntp
            if index == 0 then
                index = ntp
            elseif index == 1 then
                index = 0
            end
        else
            index = (ctpn + direction) % ntp
            if index < 0 then
                index = ntp + index
            end
            if index == 0 then
                index = ntp
            elseif index == 1 then
                index = 0
            else
                index = index - 1
            end
        end
        vim.cmd('tabmove ' .. index) 
    end
end


return M

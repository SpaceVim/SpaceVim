--=============================================================================
-- messletters.lua --- messletters api
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}


function M.bubble_num(num, t)
    local list = {}

    table.insert(list, {'➊', '➋', '➌', '➍', '➎', '➏', '➐', '➑', '➒', '➓'})
    table.insert(list, {'➀', '➁', '➂', '➃', '➄', '➅', '➆', '➇', '➈', '➉'})
    table.insert(list, {'⓵', '⓶', '⓷', '⓸', '⓹', '⓺', '⓻', '⓼', '⓽', '⓾'})

    local n = ''

    pcall(function ()
        n = list[t + 1][num]
    end)

    return n
end

function M.circled_num(num, t)
    local nr2char = vim.fn.nr2char
    local range = vim.fn.range
    local index = vim.fn.index
    if t == 0 then
        if num == 0 then
            return nr2char(9471)
        elseif index(range(1, 10), num) ~= -1 then
            return nr2char(10102 + num  - 1)
        elseif index(range(11, 20), num) ~= -1 then
            return nr2char(9451 + num - 11)
        else
            return ''
        end
    elseif t == 1 then
        if index(range(20), num) ~= -1 then
            if num == 0 then
                return nr2char(9450)
            else
                return nr2char(9311 + num)
            end
        else
            return ''
        end
    elseif t == 2 then
        if index(range(1, 10), num) ~= -1 then
            return nr2char(9461 + num - 1)
        else
            return ''
        end
    elseif t == 3 then
        return num
    end
end

function M.index_num(num)
    local nums = {8304, 185, 178, 179, 8308, 8309, 8310, 8311, 8312, 8313}
    if vim.fn.index(vim.fn.range(1, 10), num) ~= -1 then
        return vim.fn.nr2char(nums[num + 1])
    end
    return ''
end

function M.parenthesized_num(num)
    if vim.fn.index(vim.fn.range(1, 20), num) ~= -1 then
        return vim.fn.nr2char(9331 + num)
    else
        return ''
    end
end

function M.num_period(num)
    if vim.fn.index(vim.fn.range(1, 20), num) ~= -1 then
        return vim.fn.nr2char(9351 + num)
    else
        return ''
    end
end

return M

--=============================================================================
-- messletters.lua --- messletters api
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
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


return M

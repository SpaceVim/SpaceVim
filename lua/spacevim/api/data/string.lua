--=============================================================================
-- string.lua --- spacevim data#string api
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}


function M.trim(str)
    return str:match( "^%s*(.-)%s*$" )
end


function M.fill(str, length, ...)
    if string.len(str) > length then
    end
    
end

function M.strcharpart(str, start, ...)
    
end

function M.toggle_case(str)
    
end

function M.fill_left(str)
    
end

function M.fill_middle(str, length, ...)
    
end


function M.trim_start(str)
    
end

function M.trim_end(str)
    
end

function M.string2chars(str)
    
end

function M.matchstrpos(str, need, ...)
    
end

function M.strAllIndex(str, need, use_expr)
    
end

function M.strQ2B(str)
    
end

function M.strB2Q(str)
    
end

function M.split(str, ...)
    
end

return M

-- @todo add lua string api


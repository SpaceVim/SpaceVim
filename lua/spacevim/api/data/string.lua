

local str = {}


function str.trim(str)
=======
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



function str.fill(str, length, ...)
    if string.len(str) > length then
    end
    
end


return str
=======
function M.fill(str, length, ...)
    local v = ''
    if string.len(str) <= length then
        v = str
    else
        local rightmost= 0
        while string.len(string.sub(str, 0, rightmost)) < length do
            rightmost = rightmost + 1
        end

    end
    v = string.sub(str, 0, rightmost)
    local argvs = ...
    local char = ' '
    if argvs ~= nil then
        char = argvs[1] or char
    end
    return v .. string.rep(char, length - string.len(v))
end

function M.strcharpart(str, start, ...)
    
end

function M.toggle_case(str)
    local chars = {}
    for _, char in pairs(M.string2chars(str)) do
        local cn = string.byte(char)
        if cn >= 97 and cn <= 122 then
            table.insert(chars, string.char(cn - 32))
        elseif cn >= 65 and cn <= 90 then
            table.insert(chars, string.char(cn + 32))
        else
            table.insert(chars, char)
        end
    end
    return table.concat(chars, '')
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
    local t = {}
    for k in string.gmatch(str, '.') do table.insert(t, k) end
    return t
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


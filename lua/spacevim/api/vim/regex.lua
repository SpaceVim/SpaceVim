--=============================================================================
-- regex.lua --- use vim regex in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


-- in viml you can use =~/=~#/=~？


local M = {}

M.__cmp = require('spacevim.api').import('vim.compatible')

function M.equal(a, b, ...)
    local argv = {...}
    local ignore = argv[1] or false
    if M.__cmp.fn.matchstr(a, b) == '' then return false else return true end
end


function M.parser(regex, is_perl)
    local vim_regex = regex
    local substitute = vim.fn.substitute
    -- matchadd function needs \ before [%@&]
    vim_regex = substitute(vim_regex, [[\([%@&]\)]], [[\\\1]], 'g')

    -- non-greedy pattern
    -- replace from what to what?
    -- let vim_regex = substitute(vim_regex, '(?<!\\)\*\?', '{-}', 'g')
    -- let vim_regex = substitute(vim_regex, '(?<!\\)\+\?', '{-1,}', 'g')
    -- let vim_regex = substitute(vim_regex, '(?<!\\)\?\?', '{-0,1}', 'g')
    -- let vim_regex = substitute(vim_regex, '(?<!\\)\{(.*?)\}\?', '{-\1}', 'g')

    if is_perl then
        -- *+, ++, ?+, {m,n}+ => *, +, ?, {m,n}
        vim_regex = substitute(vim_regex, [[(?<!\\)([*+?}])\+]], [[\1]], 'g')
        -- remove (?#....)
        vim_regex = substitute(vim_regex, [[\(\?#.*?\)]], '', 'g')
        -- (?=atom) => atom\@=
        vim_regex = substitute(vim_regex, [[\(\?=(.+?)\)]], '(\1)@=', 'g')
        -- (?!atom) => atom\@!
        vim_regex = substitute(vim_regex, [[\(\?!(.+?)\)]], '(\1)@!', 'g')
        -- (?<=atom) => atom\@<=
        vim_regex = substitute(vim_regex, [[\(\?<=(.+?)\)]], [[(\1)@<=]], 'g')
        -- (?<!atom) => atom\@<!
        vim_regex = substitute(vim_regex, [[\(\?<!(.+?)\)]], [[(\1)@<!]], 'g')
        -- (?>atom) => atom\@>
        vim_regex = substitute(vim_regex, [[\(\?>(.+?)\)]], [[(\1)@>]], 'g')
    end

    -- this won't hurt although they are not the same
    vim_regex = substitute(vim_regex, [[\\A]], '^', 'g')
    vim_regex = substitute(vim_regex, [[\\z]], '$', 'g')
    vim_regex = substitute(vim_regex, [[\\B]], '', 'g')

    -- word boundary
    -- \bword\b => <word>
    vim_regex = substitute(vim_regex, [[\\b\(\w\+\)\\b]], [[<\1>]], 'g')

    -- right word boundary
    -- \bword => \<word
    vim_regex = substitute(vim_regex, [[\\b\(\w\+\)]], [[<\1]], 'g')

    -- left word boundary
    -- word\b => word\>
    vim_regex = substitute(vim_regex, [[\(\w\+\)\\b]], [[\1>]], 'g')

    -- case-insensitive
    -- (?i)abc => \cabc
    -- (?-i)abc => \Cabc
    vim_regex = substitute(vim_regex, '(?i)', [[\\c]], 'g')
    vim_regex = substitute(vim_regex, '(?-i)', [[\\C]], 'g')

    -- (?P<name>exp) => (exp)
    vim_regex = substitute(vim_regex, [[(?P<\w\+>\([^)]\+\))]], [[(\1)]], 'g')

    -- (?:exp) => %(exp)
    vim_regex =  substitute(vim_regex, [[(?:\([^)]\+\))]], [[%(\1)]], 'g')

    -- \a          bell (\x07)
    -- \f          form feed (\x0C)
    -- \v          vertical tab (\x0B)
    vim_regex = substitute(vim_regex, [[\\a]], '%x07', 'g')
    vim_regex = substitute(vim_regex, [[\\f]], '%x0C', 'g')
    vim_regex = substitute(vim_regex, [[\\v]], '%x0B', 'g')

    -- \123        octal character code (up to three digits) (when enabled)
    -- \x7F        hex character code (exactly two digits)
    -- let vim_regex = substitute(vim_regex, '\\(x[0-9A-Fa-f][0-9A-Fa-f])', '%\1', 'g')
    -- \x{10FFFF}  any hex character code corresponding to a Unicode code point
    -- \u007F      hex character code (exactly four digits)
    -- \u{7F}      any hex character code corresponding to a Unicode code point
    -- \U0000007F  hex character code (exactly eight digits)
    -- \U{7F}      any hex character code corresponding to a Unicode code point
    -- let vim_regex = substitute(vim_regex, '\\([uU])', '%\1', 'g')

    vim_regex = substitute(vim_regex, '\\[:ascii:\\]', '[\\\\x00-\\\\x7F]', 'g')
    vim_regex = substitute(vim_regex, '\\[:word:\\]', '[0-9A-Za-z_]', 'g')
    vim_regex = substitute(vim_regex, '\\[:alnum:\\]', '[^0-9A-Za-z]', 'g')
    vim_regex = substitute(vim_regex, '\\[:alpha:\\]', '[^A-Za-z]', 'g')
    vim_regex = substitute(vim_regex, '\\[:ascii:\\]', '[^\\x00-\\x7F]', 'g')
    vim_regex = substitute(vim_regex, '\\[:blank:\\]', '[^\\t ]', 'g')
    vim_regex = substitute(vim_regex, '\\[:cntrl:\\]', '[^\\x00-\\x1F\\x7F]', 'g')
    vim_regex = substitute(vim_regex, '\\[:digit:\\]', '[^0-9]', 'g')
    vim_regex = substitute(vim_regex, '\\[:graph:\\]', '[^!-~]', 'g')
    vim_regex = substitute(vim_regex, '\\[:lower:\\]', '[^a-z]', 'g')
    vim_regex = substitute(vim_regex, '\\[:print:\\]', '[^ -~]', 'g')
    vim_regex = substitute(vim_regex, '\\[:punct:\\]', '[^!-/:-@\\[-`{-~]', 'g')
    vim_regex = substitute(vim_regex, '\\[:space:\\]', '[^\\t\\n\\r ]', 'g')
    vim_regex = substitute(vim_regex, '\\[:upper:\\]', '[^A-Z]', 'g')
    vim_regex = substitute(vim_regex, '\\[:word:\\]', '[^0-9A-Za-z_]', 'g')
    vim_regex = substitute(vim_regex, '\\[:xdigit:\\]', '[^0-9A-Fa-f]', 'g')
    return [[\v]] .. vim_regex
end

return M

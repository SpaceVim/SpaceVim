--=============================================================================
-- searcher.lua --- lua searcher plugin for SpaceVim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}
local rst = {}

local function get_search_cmd(exe, expr)
    if exe == 'grep' then
        return {'grep', '-inHR', '--exclude-dir', '.git', expr, '.'}
    elseif exe == 'rg' then
        return {'rg', '-g!.git', '--hidden', '--no-heading', '--color=never', '--with-filename', '--line-number', expr, '.'}
    else
        return {exe, expr}
    end
end

local function search_stdout(id, data, event)
    for _, d in ipairs(data) do
        local info = vim.fn.split(d, [[\:\d\+\:]])
        if #info == 2 then
            local fname = info[1]
            local text = info[2]
            local lnum = string.sub(vim.fn.matchstr(d, [[\:\d\+\:]]), 2, -2)
            table.insert(rst, {
                filename = vim.fn.fnamemodify(fname, ':p'),
                lnum = lnum,
                text = text
            })
        end
    end
end

local function search_stderr(id, data, event)
    
end

local function search_exit(id, data, event)
    vim.fn.setqflist({}, 'r', {
        title = ' ' .. #rst .. ' items',
        items = rst
    })
    vim.cmd('botright copen')
end

function M.find(expr, exe)
    if expr == '' then
        expr = vim.fn.input('search expr:')
        vim.cmd('noautocmd normal! :')
    end
    rst = {}
    local id = vim.fn.jobstart(get_search_cmd(exe, expr), {
        on_stdout = search_stdout,
        on_stderr = search_stderr,
        on_exit = search_exit,
    })
    if id > 0 then
        vim.api.nvim_echo({{'searching ' .. expr, 'Comment'}}, false, {})
    end
end


return M

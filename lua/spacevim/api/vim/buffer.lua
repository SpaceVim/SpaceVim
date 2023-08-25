--=============================================================================
-- buffer.lua --- public buffer apis
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.create_buf(listed, scratch)
  return vim.api.nvim_create_buf(listed, scratch)
end

function M.set_lines(bufnr, startindex, endindex, replacement)
    if startindex < 0 then
        startindex = #vim.buffer(bufnr) + 1 + startindex
    end
    if endindex < 0 then
        endindex = #vim.buffer(bufnr) + 1 + endindex
    end
    if #replacement == endindex - startindex then
        for i = startindex, endindex - 1, 1
        do
            vim.buffer(bufnr)[i + 1] = replacement[i - startindex]
        end
    else
        if endindex < #vim.buffer(bufnr) then
            for i = endindex + 1, #vim.buffer(bufnr), 1
            do
                replacement:add(vim.buffer(bufnr)[i])
            end
        end
        for i = startindex, #replacement + startindex - 1, 1
        do
            if i + 1 > #vim.buffer(bufnr) then
                vim.buffer(bufnr):insert(replacement[i - startindex])
            else
                vim.buffer(bufnr)[i + 1] = replacement[i - startindex]
            end
        end
        for i = #replacement + startindex + 1, #vim.buffer(bufnr), 1
        do
            vim.buffer(bufnr)[#replacement + startindex + 1] = nil
        end

    end
end

function M.listed_buffers() -- {{{
  return vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 'buflisted(v:val)')
end
-- }}}

function M.resize(size, ...)
    local arg = {...}
    local cmd = arg[1] or 'vertical'
    vim.cmd(cmd .. ' resize ' .. size)
end

function M.open_pos(cmd, filename, line, col)
    vim.cmd('silent ' .. cmd .. ' ' .. filename)
    vim.fn.cursor(line, col)
end

---@param bufnr number the buffer number
---@param opt string option name
---@param value any option value
function M.set_option(bufnr, opt, value)
  
end


return M



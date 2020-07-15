local buffer = {}

-- bufnr = int(vim.eval("a:buffer"))
-- start_line = int(vim.eval("a:start"))
-- if start_line < 0:
-- start_line = len(vim.buffers[bufnr]) + 1 + start_line
-- end_line = int(vim.eval("a:end"))
-- if end_line < 0:
-- end_line = len(vim.buffers[bufnr]) + 1 + end_line
-- lines = vim.eval("a:replacement")
-- vim.buffers[bufnr][start_line:end_line] = lines
function buffer.set_lines(bufnr, startindex, endindex, replacement)
    if startindex < 0 then
        startindex = #vim.buffer(bufnr) + 1 + startindex
    end
    if endindex < 0 then
        endindex = #vim.buffer(bufnr) + 1 + startindex
    end
    -- if len(a:replacement) == a:end - a:start
    -- for i in range(a:start, a:end - 1)
    -- call setbufline(a:buffer, i + 1, a:replacement[i - a:start])
    -- endfor
    -- else
    -- endif
    if #replacement == endindex - startindex then
        -- if condition
        for i = startindex, endindex, 1
        do
            vim.buffer(bufnr)[i + 1] = replacement[i - startindex]
        end
    else
        -- else
        -- let endtext = a:end >= lct ? [] : getbufline(a:buffer, a:end + 1, '$')
        -- let replacement = a:replacement + endtext
        if endindex < #vim.buffer(bufnr) then
            -- for i in range(a:start, len(replacement) + a:start - 1)
            -- call setbufline(a:buffer, i + 1, replacement[i - a:start])
            -- endfor
            for i = endindex + 1, #vim.buffer(bufnr), 1
            do
                replacement:add(vim.buffer(bufnr)[i])
            end
            for i = startindex, #replacement + startindex, 1
            do
                vim.buffer(bufnr)[i + 1] = replacement[i - startindex]
            end
            -- call deletebufline(a:buffer,len(replacement) + a:start + 1, '$')
            for i = #replacement + startindex + 1, #vim.buffer(bufnr), 1
            do
                vim.buffer(bufnr)[#replacement + startindex + 1] = nil
            end

        end
    end
end

return buffer



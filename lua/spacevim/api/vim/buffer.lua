local M = {}

function M.set_lines(bufnr, startindex, endindex, replacement)
    if startindex < 0 then
        startindex = #vim.buffer(bufnr) + 1 + startindex
    end
    if endindex < 0 then
        endindex = #vim.buffer(bufnr) + 1 + startindex
    end
    if #replacement == endindex - startindex then
        for i = startindex, endindex, 1
        do
            vim.buffer(bufnr)[i + 1] = replacement[i - startindex]
        end
    else
        if endindex < #vim.buffer(bufnr) then
            for i = endindex + 1, #vim.buffer(bufnr), 1
            do
                replacement:add(vim.buffer(bufnr)[i])
            end
            for i = startindex, #replacement + startindex, 1
            do
                vim.buffer(bufnr)[i + 1] = replacement[i - startindex]
            end
            for i = #replacement + startindex + 1, #vim.buffer(bufnr), 1
            do
                vim.buffer(bufnr)[#replacement + startindex + 1] = nil
            end

        end
    end
end

return M



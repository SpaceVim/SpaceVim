local M = {}

local mt = {
    __index = function(table, key)
        return vim.api.nvim_buf_get_lines(table.bufnr, key - 1, key, 0)[1];
    end;
    __newindex = function(table, key, value)
        vim.api.nvim_buf_set_lines(table.bufnr, key -1, key, {value});
    end
}

setmetatable(M, mt);

function M.buffer(buffer_nr)
    M.bufnr = buffer_nr;
    return M
end

return M



local M = {}

local mt = {
    __index = function(table, key)
        return vim.api.nvim_buf_get_lines(table.bufnr, key, key, 0);
    end
}

setmetatable(M, mt);

function M.buffer(buffer_nr)
    M.bufnr = buffer_nr;
    return M
end

return M



local M = {}


function M.getchar(...)
    local status, ret = pcall(vim.fn.getchar, ...)
    if not status then
        ret = 3
    end
    if type(ret) == 'number' then return vim.fn.nr2char(ret) else return ret end
end

return M

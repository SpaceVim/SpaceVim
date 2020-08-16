

local M = {}

function M.eval(l)
    return vim.api.nvim_eval(l)
end

return M

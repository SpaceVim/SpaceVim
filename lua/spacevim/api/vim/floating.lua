--!/usr/bin/lua
local M = {}

function M.exists()
    return vim.fn.exists('*nvim_open_win') == 1
end

return M

local M = {}

function M.support_float()
    return vim.fn.exists('*nvim_open_win') == 1
end

function M.open_float(sl)
    
end

function M.close_float()
    if M._winid ~= nil then
        vim.api.nvim_win_close(M._winid, true)
    end
end

return M

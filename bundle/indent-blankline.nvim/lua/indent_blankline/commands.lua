local M = {}

M.refresh = function(bang)
    if bang then
        local win = vim.api.nvim_get_current_win()
        vim.cmd [[windo call indent_blankline#Refresh()]]
        vim.api.nvim_set_current_win(win)
    else
        vim.cmd [[call indent_blankline#Refresh()]]
    end
end

M.enable = function(bang)
    if bang then
        vim.g.indent_blankline_enabled = true
        local win = vim.api.nvim_get_current_win()
        vim.cmd [[windo call indent_blankline#Refresh()]]
        vim.api.nvim_set_current_win(win)
    else
        vim.b.indent_blankline_enabled = true
        vim.cmd [[call indent_blankline#Refresh()]]
    end
end

M.disable = function(bang)
    if bang then
        vim.g.indent_blankline_enabled = false
        local buffers = vim.api.nvim_list_bufs()
        for _, buffer in pairs(buffers) do
            vim.api.nvim_buf_clear_namespace(buffer, vim.g.indent_blankline_namespace, 1, -1)
        end
    else
        vim.b.indent_blankline_enabled = false
        vim.b.__indent_blankline_active = false
        vim.api.nvim_buf_clear_namespace(0, vim.g.indent_blankline_namespace, 1, -1)
    end
end

M.toggle = function(bang)
    if bang then
        if vim.g.indent_blankline_enabled then
            M.disable(bang)
        else
            M.enable(bang)
        end
    else
        if vim.b.__indent_blankline_active then
            M.disable(bang)
        else
            M.enable(bang)
        end
    end
end

return M

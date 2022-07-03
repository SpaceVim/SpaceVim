local M = {}

-- command! -nargs=0 Name call Hello()


function M.create_user_command(name, command, opts)
    if vim.api ~= nil and vim.api.nvim_create_user_command ~= nil then
        vim.api.nvim_create_user_command(name, command, opts)
    else
    end
end


return M

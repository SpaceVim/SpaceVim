--!/usr/bin/lua
local M = {}


function M.t(str)
    if vim.api ~= nil and vim.api.nvim_replace_termcodes ~= nil then
        -- https://github.com/neovim/neovim/issues/17369
        local ret = vim.api.nvim_replace_termcodes(str, false, true, true):gsub("\128\254X", "\128")
        return ret
    else
        -- local ret = vim.fn.execute('echon "\\' .. str .. '"')
        -- ret = ret:gsub('<80>', '\128')
        -- return ret
        return vim.eval(string.format('"\\%s"', str))
    end
end

return M

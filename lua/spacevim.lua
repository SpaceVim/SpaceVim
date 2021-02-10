local M = {}


local options = require('spacevim.opt')
local layers = require('spacevim.layer')



function M.bootstrap()

    options.init()
    layers.init()
    
end

function M.eval(l)
    if vim['api'] ~= nil then
        return vim.eval(l)
    else
        return vim.api.nvim_eval(l)
    end
end

return M

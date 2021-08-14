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

-- this is for Vim and old neovim
M.fn = setmetatable({}, {
        __index = function(t, key)
            local _fn
            if vim.api ~= nil and vim.api[key] ~= nil then
                _fn = function()
                    error(string.format("Tried to call API function with vim.fn: use vim.api.%s instead", key))
                end
            else
                _fn = function(...)
                    vim.api.nvim_call_function(key, ...)
                end
            end
            t[key] = _fn
            return _fn
        end
    })

-- this function is only for vim
function M.has(feature)
    return vim.eval('float2nr(has("' .. feature .. '"))')
end

return M

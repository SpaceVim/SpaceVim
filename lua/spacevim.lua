local M = {}


local options = require('spacevim.opt')
local layers = require('spacevim.layer')



function M.bootstrap()

    options.init()
    layers.init()

end

function M.eval(l)
    if vim.api ~= nil then
        return vim.api.nvim_eval(l)
    else
        return vim.eval(l)
    end
end

-- there is no want to call viml function in old vim and neovim

function M.call(funcname, ...)
    if vim.call ~= nil then
        return vim.call(funcname, ...)
    else
        if vim.api ~= nil then
            return vim.api.nvim_call_function(funcname, {...})
        else
            -- how to run viml function in lua
        end
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
                    return M.call(key, ...)
                end
            end
            t[key] = _fn
            return _fn
        end
    })

-- This is for vim and old neovim to use vim.o
M.vim_options = setmetatable({}, {
        __index = function(t, key)
            local _fn
            if vim.api ~= nil then
                -- for neovim
                return vim.api.nvim_get_option(key)
            else
                -- for vim
                _fn = M.eval('&' .. key)
            end
            t[key] = _fn
            return _fn
        end
    })

-- this function is only for vim
function M.has(feature)
    return M.eval('float2nr(has("' .. feature .. '"))')
end

return M

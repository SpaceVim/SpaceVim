local spacevim = {}


local options = require('spacevim.opt')
local layers = require('spacevim.layer')



function spacevim.bootstrap()

    options.init()
    layers.init()
    
end

function spacevim.eval(l)
    if vim['api'] ~= nil then
        return require('spacevim.vim').eval(l)
    else
        return require('spacevim.neovim').eval(l)
    end
end

return spacevim

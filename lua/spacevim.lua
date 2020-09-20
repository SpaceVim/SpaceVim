local spacevim = {}


local options = require('spacevim.opt')
local layers = require('spacevim.layer')



function spacevim.bootstrap()

    options.init()
    layers.init()
    
end

return spacevim

local api = {}


function api.import(name)
 return require('spacevim.api.' .. name)   
end


return api

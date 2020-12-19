local options = {}

options._opts = {}


function options.init()
    options._opts.version = '1.2.0'
    -- Change the default indentation of SpaceVim, default is 2.
    options._opts.default_indent = 2
    options._opts.expand_tab = true
end


return options

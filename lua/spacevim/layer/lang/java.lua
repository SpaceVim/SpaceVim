--=============================================================================
-- java.lua --- Java layer
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local format_on_save = true


function M.plugins()
    
end


function M.config()
    
end


function M.set_variable(var)
    format_on_save = var.format_on_save or format_on_save

end


function M.get_variable()
    return {
        'format_on_save' = format_on_save
    }
end


return M

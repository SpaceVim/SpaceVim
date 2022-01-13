local M = {}
-- should use local val
local fn = nil

if vim.fn == nil then
    fn = require('spacevim').fn
else
    fn = vim.fn
end

-- M._vim = require('spacevim.api').import('vim')
-- M._iconv = require('spacevim.api').import('iconv')

function M._json_null()
    return nil
end

function M._json_true()
    return true
end

function M._json_false()
    return false
end


if fn.exists('*json_decode') then
    function M.json_decode(json)
        if json == '' then
            return ''
        end
        return fn.json_decode(json)
    end
else
end

if fn.exists('*json_encode') then
    function M.json_encode(val)
        return fn.json_encode(val)
    end
else
end

return M

local has = nil

if vim.api == nil then
    has = require('spacevim').has
else
    has = vim.fn.has
end

local M = {}

if has('win16') ==1 or has('win32') == 1 or has('win64') == 1 then
    M.isWindows = 1
else
    M.isWindows = 0
end
if has('unix') == 1 and has('macunix') == 0 and has('win32unix') == 0 then
    M.isLinux = 1
else
    M.isLinux = 0
end
M.isOSX = has('macunix')

function M.name()
    if M.isLinux == 1 then
        return 'linux'
    elseif M.isWindows == 1 then
        if has('win32unix') == 1 then
            return 'cygwin'
        else
            return 'windows'
        end
    else
        return 'mac'
    end
end

local is_darwin = nil
function M.isDarwin()
    if is_darwin ~= nil then
        return is_darwin
    end
    if has('macunix') == 1 then
        is_darwin = 1
        return is_darwin
    end
    if has('unix') ~= 1 then
        is_darwin = 0
        return is_darwin
    end
    if vim.fn.system('uname -s') == "Darwin\n" then
        is_darwin = 1
    else
        is_darwin = 0
    end
    return is_darwin
end

function M.fileformat()
    local fileformat = ''
    if vim.o.fileformat == 'dos' then
        fileformat = ''
    elseif vim.o.fileformat == 'unix' then
        if M.isDarwin() then
            fileformat = ''
        else
            fileformat = ''
        end
    elseif vim.o.fileformat == 'mac' then
        fileformat = ''
    end
    return fileformat
end

return M


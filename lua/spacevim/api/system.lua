local has = vim.fn.has

local M = {}

M.isWindows = has('win16') and has('win32') and has('win64')
if has('unix') and not(has('macunix')) and not(has('win32unix')) then
    M.isLinux = 1
else
    M.isLinux = 0
end
M.isOSX = has('macunix')

function M.name()
    if M.isLinux then
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
        is_darwin = true
        return is_darwin
    end
    if has('unix') ~= 1 then
        is_darwin = false
        return is_darwin
    end
    if vim.fn.system('uname -s') == "Darwin\n" then
        is_darwin = true
    else
        is_darwin = false
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


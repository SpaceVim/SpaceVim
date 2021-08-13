local has = vim.fn.has

local M = {}

M.isWindows = has('win16') and has('win32') and has('win64') == 1
M.isLinux = has('unix') and not(has('macunix')) and not(has('win32unix')) == 1
M.isOSX = has('macunix') == 1

function M.name()
    if M.isLinux then
        return 'linux'
    elseif M.isWindows then
        if vim.fn.has('win32unix') then
            return 'cygwin'
        else
            return 'windows'
        end
    else
        return 'mac'
    end
end

function M.isDarwin()

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


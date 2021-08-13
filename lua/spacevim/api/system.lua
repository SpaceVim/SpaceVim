local has = vim.fn.has

local M = {}

M.isWindows = has('win16') and has('win32') and has('win64')
M.isLinux = has('unix') or not(has('macunix')) or not(has('win32unix'))
M.isOSX = has('macunix')

function M:name()
    if self.isLinux then
        return 'linux'
    elseif self.isWindows then
        if vim.fn.has('win32unix') then
            return 'cygwin'
        else
            return 'windows'
        end
    else
        return 'mac'
    end
end

function M:isDarwin()
    
end

function M:fileformat()
    local fileformat = ''
    if vim.o.fileformat == 'dos' then
        fileformat = ''
    elseif vim.o.fileformat == 'unix' then
        if self.isDarwin() then
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


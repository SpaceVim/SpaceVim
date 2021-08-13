local has = vim.fn.has

local M = {}

M.isWindows = has('win16') or has('win32') or has('win64')
M.isLinux = vim.fn.has('unix') and not(vim.fn.has('macunix')) and not(vim.fn.has('win32unix'))
M.isOSX = vim.fn.has('macunix')

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


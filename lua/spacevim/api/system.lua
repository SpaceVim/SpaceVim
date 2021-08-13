local M = {}

M.isWindows = vim.fn.has('win16')

function M.name()
    if self.isLinux then
        return 'linux'
    elseif self.isWindows then
    else
    end
end

function M.isDarwin()
    
end

function M.fileformat()
    local fileformat = ''
    if vim.o.fileformat == 'dos' then
        fileformat = ''
    end
    return fileformat
end

return M


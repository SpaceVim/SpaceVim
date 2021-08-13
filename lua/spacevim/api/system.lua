local M = {}

M.isWindows = vim.fn.has('win16')

function M.name()
    if self.isLinux then
        return 'linux'
    elseif self.isWindows then
    else
    end
end

return M


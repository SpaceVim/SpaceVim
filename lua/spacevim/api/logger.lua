local fn = nil
if vim.fn == nil then
    fn = require('spacevim').fn
else
    fn = vim.fn
end

local M = {
    ['name'] = '',
    ['silent'] = 1,
    ['level'] = 1,
    ['verbose'] = 1,
    ['file'] = '',
    ['temp'] = {},
}

local levels = {'Info', 'Warn', 'Error'}

function M.set_silent(sl)
    M.silent = sl
end

function M.set_verbose(vb)
    M.verbose = vb
end

function M.set_level(l)
    M.level = l
end

function M.error(msg)

end

function M.write(msg)

end

function M.warn(msg, ...)

end

function M.info(msg)
    if M.level <= 1 then
        local time = fn.strftime('%H:%M:%S')
        local log = '[ ' ..  M.name .. ' ] [' .. time .. '] [ ' .. levels[0] .. ' ] ' .. msg
        if M.silent == 0 and M.verbose >= 3 then
            vim.command('echom "' .. log .. '"')
        end
        M.write(log)
    end
end

function M.set_name(name)
    M.name = name
end

function M.get_name()
    return M.name
end

function M.set_file(file)
    M.file = file
end



return M

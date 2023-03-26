--=============================================================================
-- logger.lua --- logger api implemented in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local fn = vim.fn or require('spacevim').fn

local cmd = require('spacevim').cmd

local M = {
    ['name'] = '',
    ['silent'] = 1,
    ['level'] = 1,
    ['verbose'] = 1,
    ['file'] = '',
    ['temp'] = {},
}


-- 0 : log debug, info, warn, error messages
-- 1 : log info, warn, error messages
-- 2 : log warn, error messages
-- 3 : log error messages
M.levels = {'Info ', 'Warn ', 'Error', 'Debug'}
M.clock = fn.reltime()

function M.set_silent(sl)
    M.silent = sl
end

function M.set_verbose(vb)
    M.verbose = vb
end

function M.set_level(l)
    M.level = l
end

function M._build_msg(msg, l)
    msg = msg or ''
    -- local time = fn.strftime('%H:%M:%S')
    -- error(string.format("Tried to call API function with vim.fn: use vim.api.%s instead", key))
    -- local log = '[ ' ..  M.name .. ' ] [' .. time .. '] [ ' .. M.levels[l] .. '] ' .. msg
    -- change the format to 
    -- [ name ] [00:00:00:000] [level] msg
    local clock = fn.reltimefloat(fn.reltime(M.clock))
    local h = fn.float2nr(clock / 60 / 60)
    local m = fn.float2nr(clock / 60)
    local s = fn.float2nr(clock) % 60
    local mic = string.format('%00.3f', clock - fn.float2nr(clock))
    local c = string.format('%02d:%02d:%02d:%s', h, m, s, string.sub(mic, 3, -1))
    local log = string.format('[ %s ] [%s] [ %s ] %s',
        M.name,
        c,
        M.levels[l],
        msg)
    return log
end

function M.debug(msg)
    if M.level <= 0 then
        local log = M._build_msg(msg, 4)
        if M.silent == 0 and M.verbose >= 4 then
            cmd('echom "' .. log .. '"')
        end
        M.write(log)
    end
end

function M.error(msg)
    local log = M._build_msg(msg, 3)
    if M.silent == 0 and M.verbose >= 1 then
        cmd('echohl Error')
        cmd('echom "' .. log .. '"')
        cmd('echohl None')
    end
    M.write(log)
end

function M.write(msg)
    table.insert(M.temp, msg)
    if M.file ~= '' then
        if fn.isdirectory(fn.fnamemodify(M.file, ':p:h')) == 0 then
            fn.mkdir(fn.expand(fn.fnamemodify(M.file, ':p:h')), 'p')
        end
        local flags = ''
        if fn.filereadable(M.file) == 1 then
            flags = 'a'
        end
        fn.writefile({msg}, M.file, flags)
    end

end

function M.warn(msg, ...)
    if M.level <= 2 then
        local log = M._build_msg(msg, 2)
        if (M.silent == 0 and M.verbose >= 2) or select(1, ...) == 1 then
            cmd('echohl WarningMsg')
            cmd('echom "' .. log .. '"')
            cmd('echohl None')
        end
        M.write(log)
    end
end

function M.info(msg)
    if M.level <= 1 then
        local log = M._build_msg(msg, 1)
        if M.silent == 0 and M.verbose >= 3 then
            cmd('echom "' .. log .. '"')
        end
        M.write(log)
    end
end

function M.view(l)
    local info = ''
    local logs = ''
    if fn.filereadable(M.file) == 1 then
        logs = fn.readfile(M.file, '')
        info = info .. fn.join(fn.filter(logs, 'self._comp(v:val, a:l)'), "\n")
    else
        info = info .. '[ ' .. M.name .. ' ] : logger file ' .. M.file
        .. ' does not exists, only log for current process will be shown!'
        ..  "\n"
        for key, value in pairs(M.temp) do
            if M._comp(value, l) == 1 then
                info = info .. value .. "\n"
            end
        end
    end
    return info

end

function M._comp(msg, l)
    -- if a:msg =~# '\[ ' . self.name . ' \] \[\d\d\:\d\d\:\d\d\] \[ '
    if string.find(msg, M.levels[2]) ~= nil then
        return 1
    elseif string.find(msg, M.levels[1]) ~= nil then
        if l > 2 then return 0 else return 1 end
    else
        if l > 1 then return 0 else return 1 end
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

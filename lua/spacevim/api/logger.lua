local fn = nil
if vim.fn == nil then
    fn = require('spacevim').fn
else
    fn = vim.fn
end

local cmd = require('spacevim').cmd

local M = {
    ['name'] = '',
    ['silent'] = 1,
    ['level'] = 1,
    ['verbose'] = 1,
    ['file'] = '',
    ['temp'] = {},
}

M.levels = {'Info', 'Warn', 'Error'}

function M.set_silent(sl)
    M.silent = sl
end

function M.set_verbose(vb)
    M.verbose = vb
end

function M.set_level(l)
    M.level = l
end

function M._build_msg(msg)
    msg = msg or ''
    local time = fn.strftime('%H:%M:%S')
    local log = '[ ' ..  M.name .. ' ] [' .. time .. '] [ ' .. M.levels[1] .. ' ] ' .. msg
    return log
end

function M.error(msg)
    local log = M._build_msg(msg)
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
    local log = M._build_msg(msg)
    if M.level <= 2 then
        if (M.silent == 0 and M.verbose >= 2) or select(1, ...) == 1 then
            cmd('echohl WarningMsg')
            cmd('echom "' .. log .. '"')
            cmd('echohl None')
        end
    end
    M.write(log)
end

function M.info(msg)
    local log = M._build_msg(msg)
    if M.level <= 1 then
        if M.silent == 0 and M.verbose >= 3 then
            cmd('echom "' .. log .. '"')
        end
    end
    M.write(log)
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
    return 1
  -- if a:msg =~# '\[ ' . self.name . ' \] \[\d\d\:\d\d\:\d\d\] \[ '
        -- \ . s:levels[2] . ' \]'
    -- return 1
  -- elseif a:msg =~# '\[ ' . self.name . ' \] \[\d\d\:\d\d\:\d\d\] \[ '
        -- \ . s:levels[1] . ' \]'
    -- if a:l > 2
      -- return 0
    -- else
      -- return 1
    -- endif
  -- else
    -- if a:l > 1
      -- return 0
    -- else
      -- return 1
    -- endif
  -- endif
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

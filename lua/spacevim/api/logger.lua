--=============================================================================
-- logger.lua --- logger api implemented in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local fn = vim.fn or require('spacevim').fn

local cmd = require('spacevim').cmd
local nt = require('spacevim.api.notify')

-- a log object:
-- {
-- name:
-- time:
-- info:
-- level:
-- }

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
M.levels = { 'Info ', 'Warn ', 'Error', 'Debug' }
M.clock = fn.reltime()

function M.set_silent(sl)
  M.silent = sl
end

function M.set_verbose(vb)
  M.verbose = vb
end

function M.set_level(l)
  -- the level only can be:
  -- 0 : log debug, info, warn, error messages
  -- 1 : log info, warn, error messages
  -- 2 : log warn, error messages
  -- 3 : log error messages
  if l == 0 or l == 1 or l == 2 or l == 3 then
    M.level = l
  end
end

function M._build_msg(msg, l)
  msg = msg or ''
  local _, mic = vim.loop.gettimeofday()
  local c = string.format("%s:%03d", os.date("%H:%M:%S"), mic / 1000)
  -- local log = string.format('[ %s ] [%s] [ %s ] %s', M.name, c, M.levels[l], msg)

  return  {
    name = M.name,
    time = c,
    msg = msg,
    level = l
  }

  
end

function M.debug(msg)
  if M.level <= 0 then
    local log = M._build_msg(msg, 4)
    if M.silent == 0 and M.verbose >= 4 then
      nt.notify(msg)
    end
    M.write(log)
  end
end

function M.error(msg)
  local log = M._build_msg(msg, 3)
  if M.silent == 0 and M.verbose >= 1 then
    nt.notify(msg, 'Error')
  end
  M.write(log)
end

local function log_to_string(log)
  return ''
end

function M.write(log)
  table.insert(M.temp, log)
  if M.file ~= '' then
    if fn.isdirectory(fn.fnamemodify(M.file, ':p:h')) == 0 then
      fn.mkdir(fn.expand(fn.fnamemodify(M.file, ':p:h')), 'p')
    end
    local flags = ''
    if fn.filereadable(M.file) == 1 then
      flags = 'a'
    end
    fn.writefile({ log_to_string(log) }, M.file, flags)
  end
end

function M.warn(msg, ...)
  if M.level <= 2 then
    local log = M._build_msg(msg, 2)
    if (M.silent == 0 and M.verbose >= 2) or select(1, ...) == 0 then
      nt.notify(msg, 'WarningMsg')
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
    info = info .. fn.join(fn.filter(logs, 'self._comp(v:val, a:l)'), '\n')
  else
    info = info
      .. '[ '
      .. M.name
      .. ' ] : logger file '
      .. M.file
      .. ' does not exists, only log for current process will be shown!'
      .. '\n'
    for _, log in ipairs(M.temp) do
      if log.level >= l then
        info = info .. log_to_string(log) .. '\n'
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
    if l > 2 then
      return 0
    else
      return 1
    end
  else
    if l > 1 then
      return 0
    else
      return 1
    end
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

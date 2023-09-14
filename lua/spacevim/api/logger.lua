--=============================================================================
-- logger.lua --- logger api implemented in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local fn = vim.fn or require('spacevim').fn

local nt = require('spacevim.api.notify')

local rtplog = {}

-- a log object:
-- {
-- name:
-- time:
-- info:
-- level:
-- }

local M = {
  name = '',
  silent = true,
  level = 1,
  verbose = true,
  file = '',
  temp = {},
}

-- 0 : log debug, info, warn, error messages
-- 1 : log info, warn, error messages
-- 2 : log warn, error messages
-- 3 : log error messages
M.levels = { 'Info ', 'Warn ', 'Error', 'Debug' }
M.clock = fn.reltime()

function M.set_silent(sl)
  if type(sl) == 'boolean' then
    M.silent = sl
  end
end

function M.set_verbose(vb)
  if type(vb) == 'boolean' then
    M.verbose = vb
  end
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
  local c = string.format('%s:%03d', os.date('%H:%M:%S'), mic / 1000)
  -- local log = string.format('[ %s ] [%s] [ %s ] %s', M.name, c, M.levels[l], msg)

  return {
    name = M.name,
    time = c,
    msg = msg,
    level = l,
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
  return string.format('[ %s ] [%s] [ %s ] %s', log.name, log.time, M.levels[log.level], log.msg)
end

function M.write(log)
  table.insert(M.temp, log)
  table.insert(rtplog, log_to_string(log))
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
      nt.notify(msg)
    end
    M.write(log)
  end
end

local function read_log_from_file(f) end

function M.view_all()
  local info = ''
  info = info
    .. '[ '
    .. M.name
    .. ' ] : logger file '
    .. M.file
    .. ' does not exists, only log for current process will be shown!'
    .. '\n'
    .. table.concat(rtplog, '\n')
  return info
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

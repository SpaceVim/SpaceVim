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

local M = {
  name = '',
  silent = 1,
  level = 1,
  verbose = 1,
  file = '',
  temp = {},
}

M.levels = { 'Info ', 'Warn ', 'Error', 'Debug' }
M.clock = fn.reltime()

function M.set_silent(sl)
  if type(sl) == 'boolean' then
    M.silent = sl
  elseif type(sl) == 'number' then
    -- this is for backward compatibility.
    if sl == 1 then
      M.silent = true
    elseif sl == 0 then
      M.silent = false
    end
  end
end

function M.set_verbose(vb)
  -- verbose should be 1 - 4
  -- message type: log debug, info, warn, error
  -- info and debug should not be print to screen.
  -- the default verbose is 1
  -- 1: notify nothing
  -- 2: notify only error
  -- 3: notify warn and error
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
  local c = string.format('%s:%03d', os.date('%H:%M:%S'), mic / 1000)
  -- local log = string.format('[ %s ] [%s] [ %s ] %s', M.name, c, M.levels[l], msg)

  return {
    name = M.name,
    time = c,
    msg = msg,
    level = l,
    str = string.format('[ %s ] [%s] [ %s ] %s', M.name, c, M.levels[l], msg),
  }
end

function M.write(log)
  table.insert(M.temp, log)
  table.insert(rtplog, log.str)
end

function M.debug(msg)
  if M.level <= 0 then
    local log = M._build_msg(msg, 4)
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

function M.warn(msg, ...)
  if M.level <= 2 then
    local log = M._build_msg(msg, 2)
    local issilent = select(1, ...)
    if type(issilent) == 'number' then
      if issilent == 1 then
        issilent = true
      else
        issilent = false
      end
    elseif type(issilent) ~= 'boolean' then
      issilent = false
    end
    if not issilent then
      nt.notify(msg, 'WarningMsg')
    else
      if not M.silent and M.verbose >= 2 then
        nt.notify(msg, 'WarningMsg')
      end
    end
    M.write(log)
  end
end

function M.info(msg)
  if M.level <= 1 then
    local log = M._build_msg(msg, 1)
    M.write(log)
  end
end

function M.view_all()
  local info = table.concat(rtplog, '\n')
  return info
end

function M.view(l)
  local info = ''
  for _, log in ipairs(M.temp) do
    if log.level >= l then
      info = info .. log.str .. '\n'
    end
  end
  return info
end

function M.set_name(name)
  if type(name) == 'string' then
    M.name = name
  end
end

function M.get_name()
  return M.name
end

return M

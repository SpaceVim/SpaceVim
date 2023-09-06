--=============================================================================
-- spinners.lua --- spinners api
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local log = require('spacevim.logger').derive('spinners')

M._data = {
  dot1 = {
    frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
    strwidth = 1,
    timeout = 80,
  },
}

M._id = 0

function M.Onframe(...)
  if M.index < #M.spinners then
    M.index = M.index + 1
  else
    M.index = 1
  end
  if type(M.func) == 'function' then
    local ok, err = pcall(M.func, M.spinners[M.index])
    if not ok then
      log.debug('failed to call spinners functions:\n')
      log.debug(err)
    end
  end
end

function M.stop()
  if M.timer_id then
    vim.fn.timer_stop(M.timer_id)
    M.timer_id = nil
  end
end

-- if var is a function, then the function will be called with one argv
function M.apply(name, var)
  local data = M._data[name]

  if not data then
    log.debug('faile to apply spinners, no data named ' .. name)
    return
  end
  local time = data.timeout or 80
  M.index = 1
  M.spinners = M._data[name].frames
  if type(var) == 'function' then
    M.func = var
    M.func(M.spinners[M.index])
  end
  M.timer_id = vim.fn.timer_start(time, M.Onframe, { ['repeat'] = -1 })
  return { M.timer_id, M._data[name].strwidth }
end

function M.get_str()
  return M.str
end

return M

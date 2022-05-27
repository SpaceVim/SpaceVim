local M = {}

M.traceback_error = function(s, level)
  local traceback = debug.traceback()
  traceback = traceback .. "\n" .. s
  error(traceback, (level or 1) + 1)
end

M.info_error = function(s, func_info, level)
  local info = debug.getinfo(func_info)
  info = info .. "\n" .. s
  error(info, (level or 1) + 1)
end

return M

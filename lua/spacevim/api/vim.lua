local M = {}

function M.getchar(...)
  local status, ret = pcall(vim.fn.getchar, ...)
  if not status then
    ret = 3
  end
  if type(ret) == 'number' then
    return vim.fn.nr2char(ret)
  else
    return ret
  end
end

function M.getchar2nr(...)
  local status, ret = pcall(vim.fn.getchar, ...)
  if not status then
    ret = 3
  end
  if type(ret) == 'number' then
    return ret
  else
    return vim.fn.char2nr(ret)
  end
end

function M.empty(expr)
  return vim.fn.empty(expr) == 1
end

function M.executable(bin)
  return vim.fn.executable(bin) == 1
end

return M

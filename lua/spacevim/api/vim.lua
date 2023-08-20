local M = {}

function M.getchar(...)
  if vim.fn.empty(vim.g._spacevim_input_list) == 0 then
    local input_list = vim.g._spacevim_input_list
    local input_timeout = vim.g._spacevim_input_timeout or 0
    if input_timeout > 0 then
      vim.cmd('sleep ' .. input_timeout .. 'm')
    end
    local char = table.remove(input_list, 1)
    vim.g._spacevim_input_list = input_list
    return char

  end
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

function M.setbufvar(buf, opts)
  
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

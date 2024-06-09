local M = {}

function M.current_time()
  return vim.fn.strftime('%I:%M %p')
end

function M.current_date()
  return vim.fn.strftime('%a %b %d')
end

return M

local M = {}

local util = require('format.util')
local task = require('format.task')

local custom_formatters = {}

function M.format(bang, user_input, start_line, end_line)
  if not vim.o.modifiable then
    return util.msg('buffer is not modifiable!')
  end

  local filetype = vim.o.filetype

  if filetype == '' then
    return util.msg('format: skip empty filetype')
  end
  local ok, formatter
  if custom_formatters[filetype] then
    formatter = custom_formatters[filetype]
  end

  if not formatter then
    ok, formatter = pcall(require, 'format.ft.' .. filetype)
    if not ok then
      return util.msg('no formatter for ' .. filetype)
    end
  end

  task.run({
    bufnr = vim.fn.bufnr(),
    stdin = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line - 1, false),
    start_line = start_line - 1,
    end_line = end_line - 1,
    formatter = formatter,
  })
end

function M.setup(opt)
  if opt.custom_formatters and type(opt.custom_formatters) == 'table' then
    for k, v in pairs(opt.custom_formatters) do
      custom_formatters[k] = v
    end
  end
end
return M

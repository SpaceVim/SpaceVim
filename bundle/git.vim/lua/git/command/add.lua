local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local function replace_argvs(argvs)
  local rst = {}

  for _, v in ipairs(argvs) do
    if v == '%' then
      table.insert(rst, vim.fn.expand('%'))
    else
      table.insert(rst, v)
    end
  end
  return rst
end

local function on_exit(id, code, single)
  log.debug('git-add exit code:' .. code .. ' single:' .. single)

  if code == 0 and single == 0 then
    if vim.fn.exists(':GitGutter') == 2 then
      vim.cmd('GitGutter')
    end
    nt.notify('stage files done!')
  else
    nt.notify('stage files failed!')
  end
end

function M.run(argv)
  log.debug('argv is:' .. vim.inspect(argv))
  local cmd = { 'git', 'add' }
  for _, v in ipairs(replace_argvs(argv)) do
    table.insert(cmd, v)
  end
  job.start(cmd, { on_exit = on_exit })
end

function M.complete(ArgLead, CmdLine, CursorPos)
  local rst = vim.fn.getcompletion(ArgLead, 'file')
  table.insert(rst, '%')
  return table.concat(rst, '\n')
end

return M

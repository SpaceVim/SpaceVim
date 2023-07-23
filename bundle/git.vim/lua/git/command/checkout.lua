local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')
local branch = require('git.command.branch')

local function on_exit(id, code, single)
  log.debug('git-checkout exit code:' .. code .. ' single:' .. single)
  if code == 0 and single == 0 then
    vim.cmd('silent! checktime')
    branch.detect()
    nt.notify('checkout done.')
  else
    nt.notify('checkout failed.', 'WarningMsg')
  end
end

function M.run(argv)
  local cmd = { 'git', 'checkout' }
  for _, v in ipairs(argv) do
    table.insert(cmd, v)
  end
  job.start(cmd, { on_exit = on_exit })
end

return M

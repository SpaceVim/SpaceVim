local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local function on_exit(id, code, single)
  log.debug('git-clean exit code:' .. code .. ' single:' .. single)
  if code == 0 and single == 0 then
    nt.notify('git clean successfully')
  else
    nt.notify('failed to run git clean', 'WarningMsg')
  end
end

function M.run(argv)
  local cmd = {'git', 'clean'}
  for _, v in ipairs(argv) do table.insert(cmd, v)
  end
  log.debug('git-clean cmd:' .. vim.inspect(cmd))
  job.start(cmd, {
    on_exit = on_exit
  })
end

return M

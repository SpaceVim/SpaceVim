local m = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local function on_exit(id, code, single)
  log.debug('git-mv exit code:' .. code .. ' single:' .. single)
  if code == 0 and single == 0 then
    nt.notify('git mv successfully')
  else
    nt.notify('failed to run git mv', 'warningmsg')
  end
end

function m.run(argv)
  local cmd = {'git', 'mv'}
  if vim.fn.index(argv, '%') ~= -1 then
    argv[vim.fn.index(argv, '%') + 1] = vim.fn.expand('%')
  end
  for _, v in ipairs(argv) do table.insert(cmd, v)
  end
  log.debug('git-mv cmd:' .. vim.inspect(cmd))
  job.start(cmd, {
    on_exit = on_exit
  })
end

return m


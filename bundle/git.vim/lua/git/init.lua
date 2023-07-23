local M = {}

local log = require('git.log')

function M.run(command, ...)
  local argv = {...}
  local ok, cmd = pcall(require, 'git.command.' .. command)
  if ok and type(cmd.run) == "function" then
    cmd.run(argv)
  else
    error(cmd)
  end
end

return M

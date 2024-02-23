local M = {}

local log = require('git.log')

function M.run(command, ...)
  local argv = { ... }
  local ok, cmd = pcall(require, 'git.command.' .. command)
  if ok then
    if type(cmd.run) == 'function' then
      cmd.run(argv)
    else
      vim.api.nvim_echo(
        { { 'git.command.' .. command .. '.run  is not function', 'WarningMsg' } },
        false,
        {}
      )
    end
  else
    error(cmd)
  end
end

return M

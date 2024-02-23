local M = {}

local log = require('git.log')

local cmds = {
  'add',
  'blame',
  'branch',
  'checkout',
  'cherry-pick',
  'clean',
  'commit',
  'diff',
  'fetch',
  'log',
  'merge',
  'mv',
  'pull',
  'push',
  'remote',
  'reset',
  'rm',
  'shortlog',
  'status',
}
local supported_commands = {}

local function update_cmd()
  for _, v in ipairs(cmds) do
    supported_commands[v] = true
  end
end

update_cmd()


function M.run(command, ...)

  if not supported_commands[command] then
      vim.api.nvim_echo(
        { { ':Git ' .. command .. ' is not supported', 'WarningMsg' } },
        false,
        {}
      )
    return
  end
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

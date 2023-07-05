--=============================================================================
-- job.lua --- 
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local uv = vim.loop




function M.start(cmd, opts) -- {{{
  local command = ''
  if type(cmd) == "string" then
    command = 'cmd.exe'
  elseif type(cmd) == "table" then
    command = cmd[1]
  end

  uv.spawn(command, opt, exit_cb)
end
-- }}}


return M

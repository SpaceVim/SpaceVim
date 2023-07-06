--=============================================================================
-- init.lua --- ctags plugin
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}

local log = require('spacevim.logger').derive('ctags')
local job = require('spacevim.api.job')

local version_checked = false
local gtags_ctags_bin = 'ctags'
local is_u_ctags = false

local function version_std_out(id, data, event) -- {{{
  for _, line in ipairs(data) do
    if vim.startswith(line, 'Universal Ctags') then
      is_u_ctags = true
      break
    end
  end
end
-- }}}

local function version_exit(id, code, singin) -- {{{
  if code == 0 and singin == 0 then
    version_checked = true
    log.info('ctags version checking done:')
    log.info('      ctags bin:' .. gtags_ctags_bin)
  end
end
-- }}}


function M.update() -- {{{
  if not version_checked then
    log.info('start to check ctags version')
    job.start({gtags_ctags_bin, '--version'}, {
      on_stdout = version_std_out,
      on_exit = version_exit
    })
    return
  end
end
-- }}}

return M

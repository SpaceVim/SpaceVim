--=============================================================================
-- logevents.lua --- log events
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local log = require('spacevim.logger').derive('logevent')
local notify = require('spacevim.api.notify')

local enabled = false

function M.toggle()
  if not enabled then
    notify.notify('logevent enabled')
    local group = vim.api.nvim_create_augroup('logevent', { clear = true })
    vim.api.nvim_create_autocmd(
      vim.tbl_filter(function(e)
        return not vim.endswith(e, 'Cmd') and e ~= 'SafeState'
      end, vim.fn.getcompletion('', 'event')),
      {
        callback = vim.schedule_wrap(function(event)
          log.debug(event.event .. event.buf)
        end),
        group = group,
      }
    )
    
    enabled = true
  else
    notify.notify('logevent disabled')
    vim.api.nvim_create_augroup('logevent', { clear = true })
    enabled = false
  end
end

return M

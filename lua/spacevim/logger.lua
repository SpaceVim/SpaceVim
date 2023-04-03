--=============================================================================
-- logger.lua --- logger implemented in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.api').import('logger')
local cmd = require('spacevim').cmd
local call = require('spacevim').call
local echo = require('spacevim').echo
local fn = nil
if vim.fn == nil then
  fn = require('spacevim').fn
else
  fn = vim.fn
end

logger.set_name('SpaceVim')
logger.set_level(1)
logger.set_silent(1)
logger.set_verbose(1)

function M.info(msg)
  logger.info(msg)
end

function M.warn(msg, ...)
  logger.warn(msg, ...)
end

function M.error(msg)
  logger.error(msg)
end

function M.debug(msg)
  logger.debug(msg)
end

function M.setLevel(level)
  logger.set_level(level)
end

function M.setOutput(file)
  logger.set_file(file)
end

function M.viewRuntimeLog()
  local info = '### SpaceVim runtime log :\n\n' .. logger.view(logger.level)
  cmd('tabnew')
  cmd('setl nobuflisted')
  cmd('nnoremap <buffer><silent> q :tabclose!<CR>')
  -- put info into buffer
  fn.append(0, fn.split(info, '\n'))
  cmd('setl nomodifiable')
  cmd('setl buftype=nofile')
  cmd('setl filetype=SpaceVimLog')
  -- M.syntax_extra()
end

function M.viewLog(...)
  local argvs = { ... }
  local info = '<details><summary> SpaceVim debug information </summary>\n\n'
    .. '### SpaceVim options :\n\n'
    .. '```toml\n'
    .. fn.join(call('SpaceVim#options#list'), '\n')
    .. '\n```\n'
    .. '\n\n'
    .. '### SpaceVim layers :\n\n'
    .. call('SpaceVim#layers#report')
    .. '\n\n'
    .. '### SpaceVim Health checking :\n\n'
    .. call('SpaceVim#health#report')
    .. '\n\n'
    .. '### SpaceVim runtime log :\n\n'
    .. '```log\n'
    .. logger.view(logger.level)
    .. '\n```\n</details>\n\n'
  if argvs ~= nil and #argvs >= 1 then
    local bang = argvs[1]
    if bang == 1 then
      cmd('tabnew')
      cmd('setl nobuflisted')
      cmd('nnoremap <buffer><silent> q :tabclose!<CR>')
      -- put info into buffer
      fn.append(0, fn.split(info, '\n'))
      cmd('setl nomodifiable')
      cmd('setl buftype=nofile')
      cmd('setl filetype=markdown')
    else
      echo(info)
    end
  else
    return info
  end
end

function M.syntax_extra()
  fn.matchadd('ErrorMsg', '.*[\\sError\\s\\].*')
  fn.matchadd('WarningMsg', '.*[\\sWarn\\s\\].*')
end

function M.derive(name)
  local derive = {
    origin_name = logger.get_name(),
    _debug_mode = false,
    derive_name = fn.printf('%' .. fn.strdisplaywidth(logger.get_name()) .. 'S', name),
  }

  function derive.info(msg)
    logger.set_name(derive.derive_name)
    logger.info(msg)
    logger.set_name(derive.origin_name)
  end
  function derive.warn(msg)
    logger.set_name(derive.derive_name)
    logger.warn(msg)
    logger.set_name(derive.origin_name)
  end
  function derive.error(msg)
    logger.set_name(derive.derive_name)
    logger.error(msg)
    logger.set_name(derive.origin_name)
  end

  function derive.debug(msg)
    if derive._debug_mode then
      logger.set_name(derive.derive_name)
      logger.debug(msg)
      logger.set_name(derive.origin_name)
    end
  end
  function derive.start_debug()
    derive._debug_mode = true
  end
  function derive.stop_debug()
    derive._debug_mode = false
  end
  function derive.debug_enabled() -- {{{
    return derive._debug_mode
  end
  -- }}}
  return derive
end

return M

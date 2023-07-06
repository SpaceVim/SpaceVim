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
local f = require('spacevim.api.file')

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
    M.update()
  end
end
-- }}}

local function on_update_exit(id, code, single) -- {{{
  if code == 0 and single == 0 then
    log.info('ctags database updated successfully')
  else
    log.warn('failed to update ctags database, exit code:' .. code .. ' single:' .. single)
  end
end
-- }}}
local function on_update_stdout(id, data, event) -- {{{
  for _, d in ipairs(data) do
    log.debug('stdout:' .. d)
  end
end
-- }}}

local function on_update_stderr(id, data, event) -- {{{
  for _, d in ipairs(data) do
    log.debug('stderr:' .. d)
  end
end
-- }}}

local function extend(t1, t2) -- {{{
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end
-- }}}
function M.update() -- {{{
  gtags_ctags_bin = vim.g.gtags_ctags_bin or gtags_ctags_bin
  local project_root = vim.fn.getcwd()
  if not version_checked then
    log.info('start to check ctags version')
    job.start({ gtags_ctags_bin, '--version' }, {
      on_stdout = version_std_out,
      on_exit = version_exit,
    })
    return
  else
    log.info('update ctags database for ' .. project_root)
  end
  local dir = f.unify_path(vim.g.tags_cache_dir) .. f.path_to_fname(project_root)
  local cmd = { gtags_ctags_bin }
  if is_u_ctags then
    table.insert(cmd, '-G')
  end
  if vim.fn.isdirectory(dir) == 0 then
    if vim.fn.mkdir(dir, 'p') == 0 then
      log.warn('failed to create database dir:' .. dir)
      return
    end
  end

  if vim.fn.isdirectory(dir) == 1 then
    extend(cmd, { '-R', '--extra=+f', '-o', dir .. '/tags', project_root })
    log.debug('ctags command:' .. vim.inspect(cmd))
    local jobid = job.start(cmd, {
      on_stdout = on_update_stdout,
      on_stderr = on_update_stderr,
      on_exit = on_update_exit,
    })
    if jobid <= 0 then
      log.debug('failed to start ctags job, return jobid:' .. jobid)
    end
  end
end
-- }}}

return M

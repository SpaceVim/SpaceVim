--!/usr/bin/lua

local M = {}

local function executable(exe) -- {{{
  return vim.fn.executable(exe) == 1
end
-- }}}

local logger = require('spacevim.logger').derive('bundle')
local nt = require('spacevim.api').import('notify')
local jobs = {}

local function rename_exit(id, data, event) -- {{{
  logger.info('extract job exit code:' .. data)
  if data == 0 then
    local b = jobs['rename_id_' .. id]
    if b then
      nt.notify('update bundle files')
    end
  end
end
-- }}}

local function rename_bundle(id, data, evet) -- {{{
  logger.info('extract job exit code:' .. data)
  if data == 0 then
    local b = jobs['remove_old_bundle_id_' .. id]
    if b then
      local p
      if b.branch then
        p = '/refs/heads/' .. b.branch
      elseif b.commit then
        p = '/archive/' .. b.commit
      end
      local target = vim.fn.stdpath('run') .. '/' .. b.username .. '/' .. b.repo .. p
      if b.branch then
        p = b.repo .. '-' .. b.branch
      elseif b.commit then
        p = b.repo .. '-' .. b.commit
      end
      target = target .. '/' .. p
      local cmd = { 'mv', target, 'bundle/' .. b.directory }
      logger.info(vim.inspect(cmd))
      local jobid = vim.fn.jobstart(cmd, { on_exit = rename_exit })
      logger.info('job id is:' .. jobid)
      if jobid > 0 then
        jobs['rename_id_' .. jobid] = b
      end
    end
  end
end
-- }}}

local function remove_old_bundle(id, data, event) -- {{{
  logger.info('extract job exit code:' .. data)
  if data == 0 then
    local b = jobs['extract_id_' .. id]
    if b then
      local old_bundle = 'bundle/' .. b.directory
      local cmd = { 'rm', '-rf', old_bundle }
      logger.info(vim.inspect(cmd))
      local jobid = vim.fn.jobstart(cmd, { on_exit = rename_bundle })
      logger.info('job id is:' .. jobid)
      if jobid > 0 then
        jobs['remove_old_bundle_id_' .. jobid] = b
      end
    end
  end
  
end
-- }}}

local function extract(b) -- {{{
  if not executable('unzip') then
    nt.notify('unzip is not executable!')
    return
  end
  local p
  if b.branch then
    p = '/refs/heads/' .. b.branch
  elseif b.commit then
    p = '/archive/' .. b.commit
  end
  local target = vim.fn.stdpath('run') .. '/' .. b.username .. '/' .. b.repo .. p
  local zipfile = vim.fn.stdpath('run') .. '/' .. b.username .. '/' .. b.repo .. p .. '.zip'
  local cmd = { 'unzip', '-d', target, zipfile }
  logger.info(vim.inspect(cmd))
  local jobid = vim.fn.jobstart(cmd, { on_exit = remove_old_bundle })
  logger.info('job id is:' .. jobid)
  if jobid > 0 then
    jobs['extract_id_' .. jobid] = b
  end
end
-- }}}

local function download_exit(id, data, event) -- {{{
  logger.info('download job exit code:' .. data)
  if data == 0 then
    local b = jobs['download_id_' .. id]
    if b then
      extract(b)
    end
  end
end
-- }}}

function M.download(b) -- {{{
  if not executable('curl') then
    nt.notify('curl is not executable!')
    return
  end
  logger.info('start to download bundle:\n' .. vim.inspect(b))
  -- local cmd = { 'curl', '-L', '--create-dirs' }
  local cmd = { 'curl', '-fLo' }
  local p
  if b.branch then
    p = '/refs/heads/' .. b.branch
  elseif b.commit then
    p = '/archive/' .. b.commit
  end
  local url = b.url .. b.username .. '/' .. b.repo .. '/' .. p .. '.zip'
  local f = vim.fn.stdpath('run') .. '/' .. b.username .. '/' .. b.repo .. p .. '.zip'
  table.insert(cmd, f)
  table.insert(cmd, '--create-dirs')
  table.insert(cmd, url)
  logger.info(vim.inspect(cmd))
  local jobid = vim.fn.jobstart(cmd, { on_exit = download_exit })
  logger.info('job id is:' .. jobid)
  if jobid > 0 then
    jobs['download_id_' .. jobid] = b
  end
end

function M.get_bundles() -- {{{
  local bs = vim.api.nvim_eval("SpaceVim#api#data#toml#get().parse_file('bundle/plugins.toml')")
  M.__bs = bs.repos
  return bs.repos
end
-- }}}

function M.complete(a, b, c) -- {{{
  if not M.__bs then
    M.get_bundles()
  end
  local rst = {}
  for _, v in pairs(M.__bs) do
    if vim.startswith(v.repo, a) then
      table.insert(rst, v.username .. '/' .. v.repo)
    end
  end
  return rst
end
-- }}}

return M

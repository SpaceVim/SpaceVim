--!/usr/bin/lua

local M = {}

local logger = require('spacevim.logger').derive('flygrep')
local jobs = {}

local function async_exit(id, data, event) -- {{{
  logger.info('async job exit code:' .. data)
end
-- }}}

local function async(b) -- {{{
  local p
  if b.branch then
    p = '/refs/heads/' .. b.branch
  elseif b.commit then
    p = '/archive/' .. b.commit
  end
  local f = vim.fn.stdpath('run') .. b.repo .. p
  local cmd = { 'rsync', '-av' }
  for _, fname in pairs(b.files) do
    table.insert(cmd, '--include')
    table.insert(cmd, fname)
  end
  table.insert(cmd, '--exclude')
  table.insert(cmd, '*')
  table.insert(cmd, f .. '.unpack')
  table.insert(cmd, 'bundle/' .. b.directory)
  local jobid = vim.fn.jobstart(cmd, { on_exit = async_exit })
  logger.info('job id is:' .. jobid)
  if jobid > 0 then
    jobs['async_id_' .. jobid] = b
  end
end
-- }}}

local function extract_exit(id, data, evet) -- {{{
  logger.info('extract job exit code:' .. data)
  if data == 0 then
    local b = jobs['extract_id_' .. id]
    if b then
      async(b)
    end
  end
end
-- }}}

local function extract(b) -- {{{
  local p
  if b.branch then
    p = '/refs/heads/' .. b.branch
  elseif b.commit then
    p = '/archive/' .. b.commit
  end
  local target = vim.fn.stdpath('run') .. b.repo .. p .. '.unpack'
  local zipfile = vim.fn.stdpath('run') .. b.repo .. p .. '.zip'
  local cmd = { 'unzip', '-d', target, zipfile }
  local jobid = vim.fn.jobstart(cmd, { on_exit = extract_exit })
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
  -- local cmd = { 'curl', '-L', '--create-dirs' }
  local cmd = { 'curl', '-fLo' }
  local p
  if b.branch then
    p = '/refs/heads/' .. b.branch
  elseif b.commit then
    p = '/archive/' .. b.commit
  end
  local url = b.url .. b.repo .. '/' .. p .. '.zip'
  local f = vim.fn.stdpath('run') .. b.repo .. p .. '.zip'
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
      table.insert(rst, v.repo)
    end
  end
  return rst
end
-- }}}

return M

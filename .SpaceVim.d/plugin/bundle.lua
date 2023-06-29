--!/usr/bin/lua

local jobs = {}

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
  vim.print(cmd)
end
-- }}}

local function download_exit(id, data, event) -- {{{
  local b = jobs['job' .. id]
  if b then
    async(b)
  end
end
-- }}}

local function download(b) -- {{{
  local cmd = { 'curl', '-L' }
  local p
  if b.branch then
    p = '/refs/heads/' .. b.branch
  elseif b.commit then
    p = '/archive/' .. b.commit
  end
  local url = b.url .. '/' .. p .. '.zip'
  table.insert(cmd, url)
  table.insert(cmd, '--output')
  local f = vim.fn.stdpath('run') .. b.repo .. p
  table.insert(cmd, f)
  local jobid = vim.fn.jobstart(cmd, { on_exit = download_exit })
  if jobid > 0 then
    jobs['job' .. jobid] = b
  end
end

local function update_bundle(b) -- {{{
  download(b)
end

local function get_bundles() -- {{{
  local bs = vim.api.nvim_eval("SpaceVim#api#data#toml#get().parse_file('bundle/plugins.toml')")
  return bs
end
-- }}}

vim.api.nvim_create_user_command('SPBundleUpdate', function(opt)
  local bundles = get_bundles()
  for _, v in pairs(bundles) do
    if v.repo == opt.fargs[1] then
      download(v)
    end
  end
end, { nargs = 1, complete = 'file' })

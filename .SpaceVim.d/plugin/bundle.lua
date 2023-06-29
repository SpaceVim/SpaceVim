--!/usr/bin/lua

local function download(b) -- {{{
  local cmd = {'curl', '-L'}
  local p
  if b.branch then p = '/refs/heads/' .. b.branch
  elseif b.commit then p = '/archive/' .. b.commit end
  local url = b.url .. '/' .. p .. '.zip'
  table.insert(cmd, url)
  table.insert(cmd, '--output')
  local f = vim.fn.stdpath('run') .. b.repo .. p
  table.insert(cmd, f)
end
-- }}}


local function async(b) -- {{{
  local p
  if b.branch then p = '/refs/heads/' .. b.branch
  elseif b.commit then p = '/archive/' .. b.commit end
  local f = vim.fn.stdpath('run') .. b.repo .. p
  local cmd = {'rsync', '-av'}
  for _, fname in pairs(b.files) do
    table.insert(cmd, '--include')
    table.insert(cmd, fname)
  end
  table.insert(cmd, '--exclude')
  table.insert(cmd, '*')
  table.insert(cmd, f .. '.unpack')
  table.insert(cmd, 'bundle/' .. b.directory)
end
-- }}}

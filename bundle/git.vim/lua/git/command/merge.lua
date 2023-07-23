local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')
local conflict_files = {}

local function on_stdout(id, data)
  for _, v in ipairs(data) do
    log.debug('git-merge stdout:' .. v)
    if vim.startswith(v, 'CONFLICT (content): Merge conflict in') then
      table.insert(conflict_files, string.sub(v, 39))
    end
  end
end

local function on_stderr(id, data)
  for _, v in ipairs(data) do
    log.debug('git-merge stderr:' .. v)
  end
end

local function list_conflict_files()
  if #conflict_files > 0 then
    local rst = {}
    for _, file in ipairs(conflict_files) do
      table.insert(rst, {
        filename = vim.fn.fnamemodify(file, ':p'),
      })
    end
    vim.fn.setqflist({}, 'r', { title = ' ' .. #rst .. ' items', items = rst })
    vim.cmd('botright copen')
  end
end

local function on_exit(id, code, single)
  log.debug('git-merge exit code:' .. code .. ' single:' .. single)
  if code == 0 and single == 0 then
    nt.notify('merged done!')
  else
    list_conflict_files()
    nt.notify('merged failed!')
  end
end

function M.run(argv)
  local cmd = { 'git', 'merge' }
  if #argv == 0 then
    return
  else
    for _, v in ipairs(argv) do
      table.insert(cmd, v)
    end
  end
  job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
end

return M

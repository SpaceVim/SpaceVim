local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')
local str = require('spacevim.api.data.string')
local branch_ui = require('git.ui.branch')

local branch_info = {}
local job_pwds = {}

local function on_stdout_show_branch(id, data)
  local b = str.trim(table.concat(data, ''))
  if #b > 0 then
    local pwd = job_pwds['jobid' .. id] or ''
    if #pwd > 0 then
      branch_info[pwd] = { name = b }
    end
  end
end

local function on_exit_show_branch(id, code, single)
  log.debug('git-branch exit code:' .. code .. ' single:' .. single)
  local pwd = job_pwds['jobid' .. id] or ''
  if branch_info[pwd] == nil and #pwd > 0 then
    branch_info[pwd] = {}
  end
  if #pwd > 0 then
    branch_info[pwd]['last_update_done'] = vim.fn.localtime()
  end
  if pwd == vim.fn.getcwd() then
    vim.cmd('redrawstatus')
  end
end

local function update_branch_name(pwd, ...)
  local force = select(1, ...)
  local cmd = { 'git', 'rev-parse', '--abbrev-ref', 'HEAD' }
  if
    force
    or vim.fn.get(vim.fn.get(branch_info, pwd, {}), 'last_update_done', 0)
      <= vim.fn.localtime() - 1
  then
    log.debug('git branch cmd:' .. vim.inspect(cmd))
    local jobid = job.start(cmd, {
      on_stdout = on_stdout_show_branch,
      on_exit = on_exit_show_branch,
      cwd = pwd,
    })
    log.debug('git branch jobid:' .. jobid)
    if jobid > 0 then
      job_pwds['jobid' .. jobid] = pwd
    end
  end
end

function M.current(...)
  local pwd = vim.fn.getcwd()
  local b = branch_info[pwd] or {}
  if vim.fn.empty(b) == 1 then
    update_branch_name(pwd)
  end
  local bname = b['name'] or ''
  local prefix = select(1, ...) or ''
  if #bname > 0 then
    return ' ' .. prefix .. ' ' .. bname .. ' '
  else
    return ''
  end
end

function M.detect()
  update_branch_name(vim.fn.getcwd(), true)
end
local branch_jobid = -1
local stderr_data = {}

local function on_stdout(id, data)
  if id ~= branch_jobid then
    return
  end
  for _, line in pairs(data) do
    nt.notify_max_width = vim.fn.max({ vim.fn.strwidth(line) + 5, nt.notify_max_width })
    nt.notify(line)
  end
end

local function on_stderr(id, data)
  if id ~= branch_jobid then
    return
  end
  for _, line in pairs(data) do
    table.insert(stderr_data, line)
  end
end

local function on_exit(id, code, single)
  M.detect()
  branch_ui.update()
  log.debug('branch exit code:' .. code .. ' single:' .. single)
  if id ~= branch_jobid then
    return
  end
  if code == 0 and single == 0 then
    for _, line in ipairs(stderr_data) do
      nt.notify(line)
    end
  else
    for _, line in ipairs(stderr_data) do
      nt.notify(line, 'WarningMsg')
    end
  end
  branch_jobid = -1
end

function M.run(argv)
  if branch_jobid ~= -1 then
    nt.notify('previous branch command is not finished')
  end

  nt.notify_max_width = vim.fn.float2nr(vim.o.columns * 0.3)

  stderr_data = {}

  local cmd = { 'git', 'branch' }

  if #argv == 0 then

    require('git.ui.branch').open()

    return
  end

  if argv then
    for _, v in ipairs(argv) do
      table.insert(cmd, v)
    end
  end
  log.debug(vim.inspect(cmd))
  branch_jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })

  if branch_jobid == -1 then
    nt.notify('`git` is not executable', 'WarningMsg')
  end
end

function M.complete(arglead, cmdline, cursorpos)
  if vim.startswith(arglead, '-') then
    return table.concat({'-d', '-D'}, '\n')
  end
  return table.concat(vim.fn.map(vim.fn.systemlist('git branch --no-merged'), 'trim(v:val)'), '\n')
end

return M

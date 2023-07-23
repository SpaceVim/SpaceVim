local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')
local str = require('spacevim.api.data.string')

local branch = ''
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
      >= vim.fn.localtime() - 1
  then
    local jobid = job.start(cmd, {
      on_stdout = on_stdout_show_branch,
      on_exit = on_exit_show_branch,
      cwd = pwd,
    })
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

return M

--=============================================================================
-- branch.lua --- branch manager ui
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local job = require('spacevim.api.job')
local log = require('git.log')
local nt = require('spacevim.api.notify')
local branch_manager_bufnr = -1
local jobid = -1
local branches = {}

local function update_buffer_context()
  local context = { 'local' }
  local remote = ''
  for _, b in ipairs(branches) do
    if b.remote ~= remote then
      table.insert(context, 'r:' .. b.remote)
      remote = b.remote
    end
    table.insert(context, '  ' .. b.name)
  end
  if branch_manager_bufnr ~= -1 and vim.api.nvim_buf_is_valid(branch_manager_bufnr) then
    vim.api.nvim_buf_set_option(branch_manager_bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(branch_manager_bufnr, 0, -1, false, context)
    vim.api.nvim_buf_set_option(branch_manager_bufnr, 'modifiable', false)
  end
end

local function on_stdout(id, data)
  if id ~= jobid then
    return
  end
  for _, line in ipairs(data) do
    log.info('>>' .. line)
    if vim.startswith(line, '  remotes/') then
      table.insert(branches, {
        name = string.sub(line, vim.fn.stridx(line, '/', 10) + 2),
        remote = vim.split(line, '/')[2],
        islocal = false,
      })
    else
      table.insert(branches, {
        name = vim.trim(line),
        remote = '',
        islocal = true,
      })
    end
  end
end

local function on_stderr(id, data)
  if id ~= jobid then
    return
  end

  for _, v in pairs(data) do
    nt.notify(v, 'WarningMsg')
  end
end

local function on_exit(id, code, signal)
  if id == jobid and code == 0 and signal == 0 then
    update_buffer_context()
  end
end

local function update()
  branches = {}

  local cmd = { 'git', 'branch', '--all' }

  jobid = job.start(cmd, {
    on_stderr = on_stderr,
    on_stdout = on_stdout,
    on_exit = on_exit,
  })
end

local function checkout_branch()
  local line = vim.fn.getline('.')
  if vim.startswith(line, '  * ') then
  elseif vim.startswith(line, ' ') then
    local branch = vim.trim(line)
    vim.cmd('Git checkout ' .. branch)
  end
end

local function delete_branch()
  local remote_line = vim.fn.search('^r:', 'bnW')
  if remote_line == 0 then
    local line = vim.fn.getline('.')
    if vim.startswith(line, '  * ') then
    elseif vim.startswith(line, ' ') then
      local branch = vim.trim(line)
      vim.cmd('Git branch -d ' .. branch)
    end
  end
end

local function view_log_of_branch()
  local remote_line = vim.fn.search('^r:', 'bnW')
  if remote_line == 0 then
    local line = vim.fn.getline('.')
    if vim.startswith(line, '  * ') then
    elseif vim.startswith(line, ' ') then
      local branch = vim.trim(line)
      vim.cmd('tabnew | Git log ' .. branch)
    end
  else
    local line = vim.fn.getline('.')
    local branch = vim.trim(line)
    local remote = string.sub(vim.fn.getline(remote_line), 3)
    vim.cmd('tabnew | Git log ' .. remote .. '/' .. branch)
  end
end

function M.open()
  if branch_manager_bufnr ~= -1 and vim.api.nvim_buf_is_valid(branch_manager_bufnr) then
    vim.api.nvim_buf_delete(branch_manager_bufnr, {
      force = true,
      unload = false,
    })
  end
  vim.api.nvim_command('topleft vsplit __git_branch_manager__')
  local lines = vim.o.columns * 30 / 100
  vim.api.nvim_command('vertical resize ' .. tostring(lines))
  vim.api.nvim_command(
    'setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable  winfixwidth'
  )
  vim.api.nvim_command('set filetype=SpaceVimGitBranchManager')
  branch_manager_bufnr = vim.api.nvim_get_current_buf()
  update()
  vim.api.nvim_buf_set_keymap(branch_manager_bufnr, 'n', '<Enter>', '', {
    callback = checkout_branch,
  })
  vim.api.nvim_buf_set_keymap(branch_manager_bufnr, 'n', 'dd', '', {
    callback = delete_branch,
  })
  vim.api.nvim_buf_set_keymap(branch_manager_bufnr, 'n', 'v', '', {
    callback = view_log_of_branch,
  })
end

function M.update()
  update()
end

return M

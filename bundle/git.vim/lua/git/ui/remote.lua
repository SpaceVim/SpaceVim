--=============================================================================
-- remote.lua --- remote manager
-- Copyright (c) 2016-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local job = require('spacevim.api.job')
local log = require('git.log')

-- script local valuables

local show_help_info = false
local update_branch_list_jobid = -1
local update_branch_list_name = ''
local update_branch_list_branches = {}
local update_branch_remote_list = {}
local updating_extra_text = ' (updating)'

-- fetch remote:

local fetch_remote_jobid = -1
local fetch_remote_name = ''

local help_info = {
  '" Git remote manager quickhelp',
  '" ============================',
  '" <CR>:    view git log',
  '" f:       fetch remote under cursor',
  '" o:       toggle display of branchs',
  '" q:       close windows"'
}


-- project_manager support

local project_manager_registered = false

local bufnr = -1

local bufname = ''

-- This should not be a list of string. it should be a list of remote object.
--
-- {
--  opened = boolean, default false
--  name = string, the remote name
--  url = ''
--  branches = {}, list of string
--  updating = boolean
-- }
local remotes = {}

-- the job to update remote list.
local list_remote_job_id = -1

local function on_stdout(id, data)
  if id ~= list_remote_job_id then
    return
  end

  for _, v in ipairs(data) do
    table.insert(remotes, {
      opened = false,
      name = v,
      url = '',
      branches = {},
    })
    table.insert(update_branch_remote_list, v)
  end
end

local function on_stderr(id, data) end

local function update_buf_context()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local context = {}
  if show_help_info then
    for _, v in ipairs(help_info) do
      table.insert(context, v)
    end
  end
  table.insert(context, '[in] ' .. vim.fn.getcwd())
  for _, v in ipairs(remotes) do
    local extra_text = ''
    if v.updating then
      extra_text = updating_extra_text
    end
    if v.opened then
      table.insert(context, '  ▼ ' .. v.name .. extra_text)
      for _, b in ipairs(v.branches) do
        table.insert(context, '        ' .. b)
      end
    else
      table.insert(context, '  ▷ ' .. v.name .. extra_text)
    end
  end
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, context)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
end

local function on_exit(id, code, signal)
  if code == 0 and signal == 0 and vim.api.nvim_buf_is_valid(bufnr) then
    update_buf_context()
  end
  if #update_branch_remote_list > 0 then
    log.debug('update_branch_remote_list is:' .. vim.inspect(update_branch_remote_list))
    M.update_branch_list(table.remove(update_branch_remote_list))
  end
end

local function update()
  remotes = {}
  local cmd = { 'git', 'remote' }
  list_remote_job_id = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
end

local function enter_win() end

local function get_cursor_info()
  local l = vim.fn.getline('.')
  local c = {}
  if vim.startswith(l, '  ▼ ') then
    c.remote = string.sub(l, 7)
  elseif vim.startswith(l, '  ▷ ') then
    c.remote = string.sub(l, 7)
  elseif vim.startswith(l, '        ') then
    local remote_line = vim.fn.search('^  ▼ ', 'bnW')
    if remote_line > 0 then
      c.branch = string.gsub(string.sub(vim.fn.getline(remote_line), 7), updating_extra_text, '') .. '/' .. string.sub(l, 12)
    end
  end

  if c.remote then
    c.remote = string.gsub(c.remote, updating_extra_text, '')
  end

  return c
end

local function view_git_log()
  local cursor_info = get_cursor_info()
  if cursor_info.branch then
    log.debug('run command:' .. 'tabnew | Git log ' .. cursor_info.branch)
    vim.api.nvim_command('tabnew | Git log ' .. cursor_info.branch)
  end
end

local function update_branch_stdout(id, data)
  -- stdout example:
  -- d89ff7896994692e7bcc6a53095c7ec2e2d780aa<Tab>refs/heads/dein-lua-job
  if id ~= update_branch_list_jobid then
    return
  end

  for _, v in ipairs(data) do
    table.insert(update_branch_list_branches, string.sub(v, 53))
  end
end

local function update_branch_exit(id, code, signal)
  if id ~= update_branch_list_jobid then
    return
  end
  update_branch_list_jobid = -1
  if code == 0 and signal == 0 then
    for _, v in ipairs(remotes) do
      if v.name == update_branch_list_name then
        v.branches = update_branch_list_branches
        v.updating = false
        update_buf_context()
        break
      end
    end
  end
  if #update_branch_remote_list > 0 then
    M.update_branch_list(table.remove(update_branch_remote_list))
  end
end

local function is_in_list(t, s)
  for _, v in ipairs(t) do
    if t == s then
      return true
    end
  end
  return false
end

function M.update_branch_list(name)
  if update_branch_list_jobid ~= -1 then
    -- jobid is not -1 means job is running, check if the name same as current job, if it is not same as current job, insert to list.
    if name ~= update_branch_list_name and not is_in_list(update_branch_remote_list, name) then
      -- 此处应该检查list里是否包含name
      table.insert(update_branch_remote_list, name)
    end
    return
  end
  update_branch_list_branches = {}
  log.debug('start to update branch list for remote:' .. name)
  update_branch_list_name = name

  update_branch_list_jobid = job.start({ 'git', 'ls-remote', '-h', update_branch_list_name }, {
    on_stdout = update_branch_stdout,
    on_exit = update_branch_exit,
  })

  log.debug('update_branch_list_jobid is:' .. update_branch_list_jobid)
end

local function toggle_remote_branch()
  local cursor_info = get_cursor_info()
  if cursor_info.remote then
    for _, v in ipairs(remotes) do
      if v.name == cursor_info.remote then
        v.opened = not v.opened
        if v.opened and #v.branches == 0 then
          -- remote tree is opened, but branch list is empty, the update the branch list.
          --
          M.update_branch_list(v.name)
        end
        update_buf_context()
        break
      end
    end
  end
end

local function toggle_help()
  if show_help_info then
    show_help_info = false
  else
    show_help_info = true
  end
  update_buf_context()
end

-- functions to fetch remote:

local function on_fetch_exit(id, code, signal)
  if id == fetch_remote_jobid and code == 0 and signal == 0 then
    M.update_branch_list(fetch_remote_name)
  end
  fetch_remote_name = ''
  fetch_remote_jobid = -1
end

local function fetch_remote()
  local cursor_info = get_cursor_info()
  if cursor_info.remote then
    fetch_remote_name = cursor_info.remote
    fetch_remote_jobid = job.start({ 'git', 'fetch', cursor_info.remote }, {
      on_exit = on_fetch_exit,
    })
    if fetch_remote_jobid > 0 then
      for _, v in ipairs(remotes) do
        if v.name == fetch_remote_name then
          v.updating = true
          update_buf_context()
          break
        end
      end
    end
  end
end

function M.open()
  if not project_manager_registered then
    require('spacevim.plugin.projectmanager').reg_callback(M.on_cwd_changed, 'git_remote_on_cwd_changed')
    project_manager_registered = true
  end
  if bufnr ~= -1 and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, {
      force = true,
      unload = false,
    })
  end
  vim.api.nvim_command('topleft vsplit __git_remote_manager__')
  local lines = vim.o.columns * 20 / 100
  vim.api.nvim_command('vertical resize ' .. tostring(lines))
  vim.api.nvim_command(
    'setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable  winfixwidth'
  )
  vim.api.nvim_command('set filetype=SpaceVimGitRemoteManager')
  bufnr = vim.api.nvim_get_current_buf()
  update()
  local id = vim.api.nvim_create_augroup('spc_git_remote_manager', {
    clear = true,
  })
  vim.api.nvim_create_autocmd({ 'BufWipeout' }, {
    group = id,
    buffer = bufnr,
    callback = enter_win,
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Enter>', '', {
    callback = view_git_log,
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'o', '', {
    callback = toggle_remote_branch,
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '?', '', {
    callback = toggle_help,
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'f', '', {
    callback = fetch_remote,
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '', {
    callback = function ()
      vim.cmd('quit')
      show_help_info = false
    end,
  })
end

function M.on_cwd_changed()
  if vim.api.nvim_buf_is_valid(bufnr) then
    update()
  end
end

return M

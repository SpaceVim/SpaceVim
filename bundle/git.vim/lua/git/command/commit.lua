local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local commit_bufnr = -1

local commit_context = {}

local commit_jobid = -1

local function on_stdout(id, data)
  if id ~= commit_jobid then
    return
  end
  for _, d in ipairs(data) do
    log.debug(d)
    table.insert(commit_context, d)
  end
end

local function on_stderr(id, data)
  if id ~= commit_jobid then
    return
  end
  for _, d in ipairs(data) do
    log.debug(d)
  end
end

local function on_exit(id, code, single)
  if id ~= commit_jobid then
    return
  end
  if commit_bufnr ~= -1 and vim.api.nvim_buf_is_valid(commit_bufnr) then
    vim.api.nvim_buf_set_lines(commit_bufnr, 0, -1, false, commit_context)
  end
end

local function BufWriteCmd()
  commit_context = vim.fn.getline(1, '$')
  vim.bo.modified = false
end

local function QuitPre()
  vim.b.git_commit_quitpre = true
end

local function on_commit_exit(id, code, single)
  log.debug('git-commit exit code:' .. code .. ' single:' .. single)
  if code == 0 and single == 0 then
    nt.notify('commit done!')
  else
    nt.notify('commit failed!' , 'WarningMsg')
  end

end

local function filter(t, f)
  local rst = {}

  for _, v in ipairs(t) do
    if f(v) then
      table.insert(rst, v)
    end
  end
  return rst
end

local function WinLeave()
  if vim.b.git_commit_quitpre then
    local cmd = { 'git', 'commit', '-F', '-' }
    local id = job.start(cmd, {
      on_exit = on_commit_exit,
    })
    job.send(
      id,
      filter(commit_context, function(var)
        return not string.find(var, '^%s*#')
      end)
    )
    job.stop(id)
  end
end

local function openCommitBuffer()
  vim.cmd([[
  10split git://commit
  normal! "_dd
  setlocal nobuflisted
  setlocal buftype=acwrite
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal modifiable
  setf git-commit
  nnoremap <buffer><silent> q :bd!<CR>
  let b:git_commit_quitpre = 0
  ]])
  local bufid = vim.fn.bufnr('%')
  local id = vim.api.nvim_create_augroup('git_commit_buffer', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufWriteCmd' }, {
    group = id,
    buffer = bufid,
    callback = BufWriteCmd,
  })
  vim.api.nvim_create_autocmd({ 'QuitPre' }, {
    group = id,
    buffer = bufid,
    callback = QuitPre,
  })
  vim.api.nvim_create_autocmd({ 'WinLeave' }, {
    group = id,
    buffer = bufid,
    callback = WinLeave,
  })
  vim.api.nvim_create_autocmd({ 'WinEnter' }, {
    group = id,
    buffer = bufid,
    callback = function()
      vim.b.git_commit_quitpre = false
    end,
  })
  return bufid
end

local function index(t, v)
  if not t then return -1 end

  return vim.fn.index(t, v)
end

function M.run(...)
  local a1 = select(1, ...)
  if index(a1, '-m') == -1 then
    if
      vim.api.nvim_buf_is_valid(commit_bufnr)
      and vim.fn.index(vim.fn.tabpagebuflist(), commit_bufnr) ~= -1
    then
      local winnr = vim.fn.bufwinnr(commit_bufnr)
      vim.cmd(winnr .. 'wincmd w')
    else
      commit_bufnr = openCommitBuffer()
    end
  else
    commit_bufnr = -1
  end
  local cmd
  commit_context = {}
  if vim.fn.empty(a1) == 1 then
    cmd = {
      'git',
      '--no-pager',
      '-c',
      'core.editor=cat',
      '-c',
      'color.status=always',
      '-C',
      vim.fn.expand(vim.fn.getcwd(), ':p'),
      'commit',
      '--edit',
    }
  elseif index(a1, '-m') ~= -1 then
    cmd = {
      'git',
      '--no-pager',
      '-c',
      'core.editor=cat',
      '-c',
      'color.status=always',
      '-C',
      vim.fn.expand(vim.fn.getcwd(), ':p'),
      'commit',
    }
    for _, v in ipairs(a1) do
      table.insert(cmd, v)
    end
  else
    cmd = {
      'git',
      '--no-pager',
      '-c',
      'core.editor=cat',
      '-c',
      'color.status=always',
      '-C',
      vim.fn.expand(vim.fn.getcwd(), ':p'),
      'commit',
    }
    for _, v in ipairs(a1) do
      table.insert(cmd, v)
    end
  end
  commit_jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_exit = on_exit,
    on_stderr = on_stderr,
  })
end

return M

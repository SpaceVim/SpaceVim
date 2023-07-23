local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')
local str = require('spacevim.api.data.string')

local git_log_pretty = 'tformat:%Cred%h%Creset - %s %Cgreen(%an %ad)%Creset'
local bufnr = -1
local jobid = -1
local commit_bufnr = -1
local show_lines = {}

local function close_commit_win()
  if vim.api.nvim_buf_is_valid(commit_bufnr) then
    vim.cmd('bd ' .. commit_bufnr)
  end
end

local function close_log_win()
  local ok = pcall(function()
    vim.cmd('bp')
  end)

  if not ok then
    vim.cmd('bd')
  end
end

local function openShowCommitBuffer()
  vim.cmd([[
  rightbelow vsplit git://show_commit
  normal! "_dd
  setl nobuflisted
  setl nomodifiable
  setl nonumber norelativenumber
  setl buftype=nofile
  setl bufhidden=wipe
  setf git-diff
  setl syntax=diff
  nnoremap <buffer><silent> q :q<CR>
  ]])
  return vim.fn.bufnr()
end

local function on_show_stdout(id, data)
  for _,v in ipairs(data) do
    log.debug('git-show stdout:' .. v)
    table.insert(show_lines, v)
  end
end

local function on_show_stderr(id, data)
  for _,v in ipairs(data) do
    log.debug('git-show stderr:' .. v)
    table.insert(show_lines, v)
  end
end

local function on_show_exit(id, code, single)
  log.debug('git-show exit code:' .. code .. ' single:' .. single)
  vim.api.nvim_buf_set_option(commit_bufnr, 'modifiable', true)
  vim.api.nvim_buf_set_lines(commit_bufnr, 0, -1, false, show_lines)
  vim.api.nvim_buf_set_option(commit_bufnr, 'modifiable', false)
end



local function show_commit()
  local commit = vim.fn.matchstr(vim.fn.getline('.'), [[^[* |\\\/_]\+\zs[a-z0-9A-Z]\+]])
  if vim.fn.empty(commit) == 1 then
    return
  end
  if not vim.api.nvim_buf_is_valid(commit_bufnr) then
    commit_bufnr = openShowCommitBuffer()
  end
  local cmd = { 'git', 'show', commit }
  show_lines = {}
  job.start(cmd, {
    on_stdout = on_show_stdout,
    on_stderr = on_show_stderr,
    on_exit = on_show_exit,
  })
end

local function openLogBuffer()
  vim.cmd([[
  edit git://log
  normal! "_dd
  setl nobuflisted
  setl nomodifiable
  setl nonumber norelativenumber
  setl buftype=nofile
  setl bufhidden=wipe
  setf git-log
  ]])
  -- nnoremap <buffer><silent> <Cr> :call <SID>show_commit()<CR>
  -- nnoremap <buffer><silent> q :call <SID>close_log_win()<CR>
  bufnr = vim.fn.bufnr()
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '', {
    callback = close_log_win,
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Cr>', '', {
    callback = show_commit,
  })
  return bufnr
end

local function on_stdout(id, data)
  if id ~= jobid then
    return
  end
  if not vim.api.nvim_buf_is_valid(bufnr) then
    bufnr = openLogBuffer()
  end
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
  if vim.api.nvim_buf_line_count(bufnr) == 1 and vim.fn.getline('$') == '' then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
  else
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
  end
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
end

local function on_stderr(id, data)
  nt.notify(data, 'WarningMsg')
end

local function on_exit(id, code, single)
  log.debug('git-log exit code:' .. code .. ' single:' .. single)
end

function M.run(argv)
  local cmd = { 'git', 'log', '--graph', '--date=relative', '--pretty=' .. git_log_pretty }
  if #argv == 1 and argv[1] == '%' then
    table.insert(cmd, vim.fn.expand('%'))
  else
    for _, v in ipairs(argv) do
      table.insert(cmd, v)
    end
  end
  log.debug('git-log cmd:' .. vim.inspect(cmd))
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  end
  jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
end

return M

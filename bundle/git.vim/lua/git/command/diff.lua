local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')
local win = require('spacevim.api.vim.window')

local diff_lines = {}
local jobid = -1

local bufnr = -1

local function on_stdout(id, data)
  if id ~= jobid then
    return
  end
  for _, v in ipairs(data) do
    log.debug('git-diff stdout:' .. v)
    table.insert(diff_lines, v)
  end
end

local function on_stderr(id, data)
  if id ~= jobid then
    return
  end
  for _, v in ipairs(data) do
    log.debug('git-diff stderr:' .. v)
    table.insert(diff_lines, v)
  end
end

local function close_diff_win()
  if win.is_last_win() then
    vim.cmd('bd!')
  else
    vim.cmd('close')
  end
end

local function open_diff_buffer()
  if vim.api.nvim_buf_is_valid(bufnr) then
    return bufnr
  end
  vim.cmd([[
    exe printf('%s git://diff', get(g:, 'git_diff_position', '10split'))
    normal! "_dd
    setl nobuflisted
    setl nomodifiable
    setl nonumber norelativenumber
    setl buftype=nofile
    setl bufhidden=wipe
    setf git-diff
    setl syntax=diff
  ]])
  bufnr = vim.fn.bufnr()
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '', {
    callback = close_diff_win,
  })
  return bufnr
end

local function on_exit(id, code, single)
  if id ~= jobid then
    return
  end
  log.debug('git-diff exit code:' .. code .. ' single:' .. single)
  if #diff_lines > 0 then
    bufnr = open_diff_buffer()
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, diff_lines)
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  else
    nt.notify('No Changes!')
  end
end

function M.run(argv)
  local cmd = { 'git', 'diff' }
  if #argv == 1 and argv[1] == '%' then
    table.insert(cmd, vim.fn.expand('%'))
  else
    for _, v in ipairs(argv) do
      table.insert(cmd, v)
    end
  end
  diff_lines = {}
  log.debug('git-dff cmd:' .. vim.inspect(cmd))
  jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
end

return M

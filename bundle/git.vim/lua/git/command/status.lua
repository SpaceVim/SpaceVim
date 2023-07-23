local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local status_bufnr = -1
local lines = {}

local function close_status_window()
  if vim.fn.winnr('$') > 1 then
    vim.cmd('close')
  else
    vim.cmd('bd!')
  end
end

local function openStatusBuffer()
  vim.cmd([[
  10split git://status
  normal! "_dd
  setl nobuflisted
  setl nomodifiable
  setl nonumber norelativenumber
  setl buftype=nofile
  setl bufhidden=wipe
  setf git-status
  ]])
  status_bufnr = vim.fn.bufnr()
  -- nnoremap <buffer><silent> q :call <SID>close_status_window()<CR>
  vim.api.nvim_buf_set_keymap(status_bufnr, 'n', 'q', '', {
    callback = close_status_window,
  })
  return status_bufnr
end

local function on_stdout(id, data)
  for _, v in ipairs(data) do
    log.debug('git-status stdout:' .. v)
    table.insert(lines, v)
  end
end

local function on_stderr(id, data)
  for _, v in ipairs(data) do
    log.debug('git-status stderr:' .. v)
    table.insert(lines, v)
  end
end

local function on_exit(id, code, single)
  log.debug('git-status exit code:' .. code .. ' single:' .. single)
  vim.api.nvim_buf_set_option(status_bufnr, 'modifiable', true)
  vim.api.nvim_buf_set_lines(status_bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(status_bufnr, 'modifiable', false)
end

function M.run(...)
  if
    vim.api.nvim_buf_is_valid(status_bufnr)
    and vim.fn.index(vim.fn.tabpagebuflist(), status_bufnr) ~= -1
  then
    local winnr = vim.fn.bufwinnr(status_bufnr)
    vim.cmd(winnr .. 'wincmd w')
  else
    status_bufnr = openStatusBuffer()
  end
  local cmd = { 'git', 'status', '.' }
  lines = {}
  job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
end

return M

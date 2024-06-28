local m = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')
local std_data = {}
local rebase_todo_bufnr = -1
local rebase_nvim_channal = ''

local function BufWriteCmd()
  vim.bo.modified = false
end

local function QuitPre()
  vim.b.git_rebase_quitpre = true
end

local function WinLeave()
  if vim.b.git_rebase_quitpre then
    local text = vim.fn.getline(1, '$')
    vim.fn.rpcrequest(rebase_nvim_channal, 'nvim_buf_set_lines', 0, 0, -1, false, text)
    vim.fn.rpcnotify(rebase_nvim_channal, 'nvim_command', 'wq')
  end
end
local function open_rebase()
  vim.cmd([[
  10split git://rebase
  normal! "_dd
  setlocal nobuflisted
  setlocal buftype=acwrite
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal modifiable
  setf git-rebase
  set syntax=gitrebase
  nnoremap <buffer><silent> q :bd!<CR>
  let b:git_commit_quitpre = 0
  ]])
end

local function open_commit()
  vim.cmd([[
  10split git://commit
  normal! "_dd
  setlocal nobuflisted
  setlocal buftype=acwrite
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal modifiable
  setf git-commit
  set syntax=gitcommit
  nnoremap <buffer><silent> q :bd!<CR>
  let b:git_commit_quitpre = 0
  ]])
end
local function create_autocmd_return_bufnr()
  local bufid = vim.fn.bufnr('%')
  local id = vim.api.nvim_create_augroup('git_rebase_todo_buffer', { clear = true })
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
      vim.b.git_rebase_quitpre = false
    end,
  })
  return bufid
end

local function on_exit(id, code, single)
  log.debug('git-rebase exit code:' .. code .. ' single:' .. single)
  if code == 0 and single == 0 then
    nt.notify('git rebase successfully')
  else
    nt.notify(table.concat(std_data, "\n"), "WarningMsg")
  end
end

local function on_std(id, data)
  for _, v in ipairs(data) do
    if vim.startswith(v, 'git-rebase-nvim-serverlist:') then
      local address = string.sub(v, 28)
      rebase_nvim_channal = vim.fn.sockconnect('pipe', address, { rpc = true })
      local bufname = vim.fn.rpcrequest(rebase_nvim_channal, 'nvim_buf_get_name', 0)
      log.debug(bufname)
      if vim.fn.fnamemodify(bufname, ':t') ==  'git-rebase-todo' then
        open_rebase()
      else
        open_commit()
      end
      rebase_todo_bufnr = create_autocmd_return_bufnr()
      local text = vim.fn.rpcrequest(rebase_nvim_channal, 'nvim_buf_get_lines', 0, 0, -1, false)
      vim.api.nvim_buf_set_lines(rebase_todo_bufnr, 0, -1, false, text)
      vim.bo.modified = false
    else
      table.insert(std_data, v)
    end
  end
end

function m.run(argv)
  local cmd = {
    'git',
    '--no-pager',
    '-c',
    [[core.editor=nvim -u NONE --headless -n --cmd "call chansend(v:stderr, ['', 'git-rebase-nvim-serverlist:' . serverlist()[0], ''])"]],
    '-c',
    'color.status=always',
    '-C',
    vim.fn.fnamemodify(vim.fn.getcwd(), ':p'),
    'rebase',
  }
  for _, v in ipairs(argv) do
    table.insert(cmd, v)
  end
  log.debug('git-rebase cmd:' .. vim.inspect(cmd))
  std_data = {}
  job.start(cmd, {
    on_exit = on_exit,
    on_stdout = on_std,
    on_stderr = on_std,
  })
end

return m

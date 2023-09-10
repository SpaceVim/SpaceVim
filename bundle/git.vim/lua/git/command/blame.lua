local M = {}

local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')
local log = require('git.log')

local blame_buffer_nr = -1
local blame_show_buffer_nr = -1

local lines = {}

local function on_stdout(id, data)
  for _, v in ipairs(data) do
    log.debug('git-blame stdout:' .. v)
    table.insert(lines, v)
  end
end

local function on_stderr(id, data)
  for _, v in ipairs(data) do
    log.debug('git-blame stderr:' .. v)
  end
end

local function parser(l)
  local rst = {}
  local obj = {}
  for _, line in ipairs(l) do
    if vim.regex('^[a-zA-Z0-9]\\{40}'):match_str(line) then
      if obj.summary and obj.line then
        table.insert(rst, obj)
      end
      obj = {}
      obj.revision = string.sub(line, 1, 40)
    elseif vim.startswith(line, 'summary') then
      obj.summary = string.sub(line, 9)
    elseif vim.startswith(line, 'filename') then
      obj.filename = string.sub(line, 10)
    elseif vim.startswith(line, 'previous') then
      obj.previous = string.sub(line, 10, 49)
    elseif vim.startswith(line, 'committer-time') then
      obj.time = tonumber(string.sub(line, 15))
    elseif vim.startswith(line, '\t') then
      obj.line = string.sub(line, 2)
    end
  end
  return rst
end

local function open_blame_win()
  vim.cmd([[
    tabedit git://blame
    normal! "_dd
    setl nobuflisted
    setl nomodifiable
    setl nonumber norelativenumber
    setl buftype=nofile
    setl scrollbind
    setf git-blame
    setlocal bufhidden=wipe
  ]])
  return vim.api.nvim_get_current_buf()
end

local function generate_context(ls)
  
end

local function on_exit(id, code, single)
  log.debug('git-blame exit code:' .. code .. ' single:' .. single)
  local rst = parser(lines)
  log.debug(vim.inspect(rst))
  if #rst > 0 then
    if not vim.api.nvim_buf_is_valid(blame_buffer_nr) then
      blame_buffer_nr = open_blame_win()
    end
    vim.fn.setbufvar(blame_buffer_nr, 'git_blame_info', rst)
    local context = generate_context(lines)
    vim.api.nvim_buf_set_lines(blame_buffer_nr, 0, -1, false, context)
  end
  
end

function M.run(argv)
  local cmd = {'git', 'blame', '--line-porcelain'}
  if #argv == 0 then
    table.insert(cmd, vim.fn.expand('%'))
  else
    for _, v in ipairs(argv) do
      table.insert(cmd, v)
    end
  end
  log.debug('git-blame cmd:' .. vim.inspect(cmd))
  lines = {}
  job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
end

return M


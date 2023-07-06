--=============================================================================
-- job.lua ---
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local uv = vim.loop

local _jobs = {}
local _jobid = 0

local function new_job_obj(id, handle, opt, state)
  local jobobj = {
    id = id,
    handle = handle,
    opt = opt,
    state = state,
  }
  return jobobj
end

--- @param cmd string|table<string> Spawns {cmd} as a job. 
--- @param opts table job options
--- @return integer # jobid if job run successfully.
--- jobid: if job run successfully
--- 0: if type of cmd is wrong
--- -1: if cmd[1] is not executable
function M.start(cmd, opts)
  local command = ''
  local argv = {}
  if type(cmd) == 'string' then
    local shell = vim.fn.split(vim.o.shell)
    local shellcmdflag = vim.fn.split(vim.o.shellcmdflag)
    -- :call jobstart(split(&shell) + split(&shellcmdflag) + ['{cmd}'])
    command = shell[1]
    argv = vim.list_slice(shell, 2)
    for _, v in ipairs(shellcmdflag) do
      table.insert(argv, v)
    end
    table.insert(argv, cmd)
  elseif type(cmd) == 'table' then
    command = cmd[1]
    if vim.fn.executable(command) == 0 then return -1 end
    argv = vim.list_slice(cmd, 2)
  else
    return 0
  end

  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  local opt = {
    stdio = { stdin, stdout, stderr },
    args = argv,
    cwd = opts.cwd or nil,
    hide = true,
    detached = opts.detached or nil
  }
  _jobid = _jobid + 1
  local current_id = _jobid
  local exit_cb
  if opts.on_exit then
    exit_cb = function(code, singin)
      vim.schedule(function()
        opts.on_exit(current_id, code, singin)
      end)
    end
  end

  local handle, pid = uv.spawn(command, opt, exit_cb)

  _jobs['jobid_' .. _jobid] = new_job_obj(_jobid, handle, opts, {
    stdout = stdout,
    stderr = stderr,
    stdin = stdin,
    pid = pid,
  })
  if opts.on_stdout then
    uv.read_start(stdout, function(err, data)
      if data then
        data = data:gsub('\r', '')
        vim.schedule(function()
          opts.on_stdout(current_id, vim.split(data, '\n'), 'stdout')
        end)
      end
    end)
  end

  if opts.on_stderr then
    uv.read_start(stderr, function(err, data)
      if data then
        data = data:gsub('\r', '')
        vim.schedule(function()
          opts.on_stderr(current_id, vim.split(data, '\n'), 'stderr')
        end)
      end
    end)
  end
  return current_id
end

function M.send(id, data) -- {{{
  local jobobj = _jobs['jobid_' .. id]

  if not jobobj then
    error('can not find job:' .. id)
  end

  local stdin = jobobj.state.stdin

  if not stdin then
    error('no stdin stream for jobid:' .. id)
  end

  if type(data) == 'table' then
    for _, v in ipairs(data) do
      stdin:write(v)
      stdin:write('\n')
    end
  elseif type(data) == 'string' then
    stdin:write(data)
  elseif data == nil then
    stdin:write('', function()
      stdin:shutdown(function()
        if stdin then
          stdin:close()
        end
      end)
    end)
  end
end

function M.chanclose(id, t)
  local jobobj = _jobs['jobid_' .. id]

  if not jobobj then
    error('can not find job:' .. id)
  end
  if t == 'stdin' then
    local stdin = jobobj.state.stdin
    if not stdin then
      stdin:shutdown(function()
        if stdin then
          stdin:close()
        end
      end)
    end
  elseif t == 'stdout' then
  elseif t == 'stderr' then
  else
    error('the type only can be:stdout, stdin or stderr')
  end
end

function M.stop(id)
  local jobobj = _jobs['jobid_' .. id]

  if not jobobj then
    return
  end

  -- close stdio
  local stdin = jobobj.state.stdin
  if stdin and stdin:is_active() then
    stdin:close()
  end
  -- close stdio
  local stdout = jobobj.state.stout
  if stdout and stdout:is_active() then
    stdout:close()
  end
  -- close stdio
  local stderr = jobobj.state.stderr
  if stderr and stderr:is_active() then
    stderr:close()
  end

  local handle = jobobj.handle
  handle:kill(6)
end

return M

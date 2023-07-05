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

function M.start(cmd, opts)
  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()
  local command = ''
  local argv = {}
  if type(cmd) == 'string' then
    command = 'cmd.exe'
    argv = { '/c', cmd }
  elseif type(cmd) == 'table' then
    command = cmd[1]
    argv = vim.list_slice(cmd, 2)
  end

  local opt = {
    stdio = { stdin, stdout, stderr },
    args = argv,
  }
  _jobid = _jobid + 1
  local current_id = _jobid
  local exit_cb
  if opts.on_exit then
    exit_cb = function(code, singin)
      opts.on_exit(current_id, code, singin)
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
        opts.on_stdout(current_id, data, 'stdout')
      end
    end)
  end

  if opts.on_stderr then
    uv.read_start(stderr, function(err, data)
      if data then
        opts.on_stderr(current_id, data, 'stderr')
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
    error('can not find job:' .. id)
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

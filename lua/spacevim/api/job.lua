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

local function buffered_data(eof, data)
  data = data:gsub('\r', '')
  local std_data = vim.split(data, '\n')
  if #std_data > 1 and std_data[#std_data] == '' then
    std_data[1] = eof .. std_data[1]
    table.remove(std_data, #std_data)
    eof = ''
  elseif #std_data > 1 then
    std_data[1] = eof .. std_data[1]
    eof = std_data[#std_data]
    table.remove(std_data, #std_data)
  elseif #std_data == 1 and std_data[1] == '' and eof ~= '' then
    std_data = { eof }
    eof = ''
  elseif #std_data == 1 and std_data[#std_data] ~= '' then
    eof = std_data[#std_data]
  end
  return eof, std_data
end

local function new_job_obj(id, handle, opt, state)
  local jobobj = {
    id = id,
    handle = handle,
    opt = opt,
    state = state,
  }
  return jobobj
end

local function default_dev() -- {{{
  local env = vim.fn.environ()
  env['NVIM'] = vim.v.servername
  env['NVIM_LISTEN_ADDRESS'] = nil
  env['NVIM_LOG_FILE'] = nil
  env['VIMRUNTIME'] = nil
  return env
end
-- }}}

local function setup_env(env, clear_env) -- {{{
  if clear_env then
    return env
  end
  --- @type table<string,string|number>
  env = vim.tbl_extend('force', default_dev(), env or {})

  local renv = {} --- @type string[]
  for k, v in pairs(env) do
    renv[#renv + 1] = string.format('%s=%s', k, tostring(v))
  end

  return renv
end
-- }}}

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
    if cmd == '' then
      return 0
    end
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
    if #cmd == 0 then
      return 0
    end
    for _, v in ipairs(cmd) do
      if type(v) ~= 'string' then
        return 0
      end
    end
    command = cmd[1]
    if command == '' then
      return 0
    end
    if vim.fn.executable(command) == 0 then
      return -1
    end
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
    detached = opts.detached or nil,
    env = setup_env(opts.env, opts.clear_env),
  }
  _jobid = _jobid + 1
  local current_id = _jobid
  local exit_cb
  if opts.on_exit then
    exit_cb = function(code, singin)
      if stdout and not stdout:is_closing() then
        stdout:close()
      end
      if stderr and not stderr:is_closing() then
        stderr:close()
      end
      if stdin and not stdin:is_closing() then
        stdin:close()
      end
      local job = _jobs['jobid_' .. current_id]

      if job and job.handle and not job.handle:is_closing() then
        job.handle:close()
      end

      vim.schedule(function()
        opts.on_exit(current_id, code, singin)
      end)
    end
  else
    exit_cb = function(code, singin)
      if stdout and not stdout:is_closing() then
        stdout:close()
      end
      if stderr and not stderr:is_closing() then
        stderr:close()
      end
      if stdin and not stdin:is_closing() then
        stdin:close()
      end
      local job = _jobs['jobid_' .. current_id]

      if job and job.handle and not job.handle:is_closing() then
        job.handle:close()
      end
    end
  end

  local handle, pid = uv.spawn(command, opt, exit_cb)

  _jobs['jobid_' .. _jobid] = new_job_obj(_jobid, handle, opts, {
    stdout = stdout,
    stderr = stderr,
    stdin = stdin,
    pid = pid,
    stderr_eof = '',
    stdout_eof = '',
  })
  -- logger.debug(vim.inspect(_jobs['jobid_' .. _jobid]))
  if opts.on_stdout then
    -- define on_stdout function based on stdout's nparams
    local nparams = debug.getinfo(opts.on_stdout).nparams
    if nparams == 2 then
      uv.read_start(stdout, function(err, data)
        if data then
          local stdout_data
          _jobs['jobid_' .. current_id].state.stdout_eof, stdout_data =
            buffered_data(_jobs['jobid_' .. current_id].state.stdout_eof, data)
          vim.schedule(function()
            opts.on_stdout(current_id, stdout_data)
          end)
        end
      end)
    else
      uv.read_start(stdout, function(err, data)
        if data then
          local stdout_data
          _jobs['jobid_' .. current_id].state.stdout_eof, stdout_data =
            buffered_data(_jobs['jobid_' .. current_id].state.stdout_eof, data)
          vim.schedule(function()
            opts.on_stdout(current_id, stdout_data, 'stdout')
          end)
        end
      end)
    end
  end

  if opts.on_stderr then
    local nparams = debug.getinfo(opts.on_stderr).nparams
    if nparams == 2 then
      uv.read_start(stderr, function(err, data)
        if data then
          local stderr_data
          _jobs['jobid_' .. current_id].state.stderr_eof, stderr_data =
            buffered_data(_jobs['jobid_' .. current_id].state.stderr_eof, data)
          vim.schedule(function()
            opts.on_stderr(current_id, stderr_data)
          end)
        end
      end)
    else
      uv.read_start(stderr, function(err, data)
        if data then
          local stderr_data
          _jobs['jobid_' .. current_id].state.stderr_eof, stderr_data =
            buffered_data(_jobs['jobid_' .. current_id].state.stderr_eof, data)
          vim.schedule(function()
            opts.on_stderr(current_id, stderr_data, 'stderr')
          end)
        end
      end)
    end
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
    stdin:write('\n')
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
    if stdin and not stdin:is_closing() then
      stdin:close()
    end
  elseif t == 'stdout' then
    local stdout = jobobj.state.stdout
    if stdout and not stdout:is_closing() then
      stdout:close()
    end
  elseif t == 'stderr' then
    local stderr = jobobj.state.stderr
    if stderr and not stderr:is_closing() then
      stderr:close()
    end
  else
    error('the type only can be:stdout, stdin or stderr')
  end
end

function M.stop(id)
  local jobobj = _jobs['jobid_' .. id]

  if not jobobj then
    return
  end

  local handle = jobobj.handle
  handle:kill(6)
end
return M

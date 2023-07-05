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

local function new_job_obj(id, handle, opt) -- {{{
end
-- }}}

function M.start(cmd, opts) -- {{{
  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()
  local command = ''
  local argv = {}
  if type(cmd) == 'string' then
    command = 'cmd.exe'
  elseif type(cmd) == 'table' then
    command = cmd[1]
    argv = vim.list_slice(cmd, 2)
  end

  local opt = {
    stdio = { stdin, stdout, stderr },
    args = argv
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

  table.insert(_jobs, {
    ['jobid_' .. _jobid] = new_job_obj(_jobid, handle, opts),
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

  -- uv.write(stdin, 'Hello World')

  uv.shutdown(stdin, function()
    -- print('stdin shutdown', stdin)
    uv.close(handle, function()
      -- print('process closed', handle, pid)
    end)
  end)
end
-- }}}

return M

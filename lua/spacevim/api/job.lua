--=============================================================================
-- job.lua ---
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local uv = vim.loop

local function exit_cb() -- {{{
end
-- }}}

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
  if type(cmd) == 'string' then
    command = 'cmd.exe'
  elseif type(cmd) == 'table' then
    command = cmd[1]
  end

  local opt = {
    stdio = { stdin, stdout, stderr },
  }

  local handle, pid = uv.spawn(command, opt, exit_cb)
  _jobid = _jobid + 1

  local current_id = _jobid

  table.insert(_jobs, {
    ['jobid_' .. _jobid] = new_job_obj(_jobid, handle, opts),
  })
  if opts.stdout then
    uv.read_start(stdout, function(err, data)
      assert(not err, err)
      if data then
        print('stdout chunk', stdout, data)
      else
        print('stdout end', stdout)
      end
    end)
  end

  if opts.stdout then
    uv.read_start(stderr, function(err, data)
      if data then
        opts.stdout(current_id, data, 'stdout')
      end
    end)
  end

  uv.write(stdin, 'Hello World')

  uv.shutdown(stdin, function()
    print('stdin shutdown', stdin)
    uv.close(handle, function()
      print('process closed', handle, pid)
    end)
  end)
end
-- }}}

return M

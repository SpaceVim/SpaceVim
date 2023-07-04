--=============================================================================
-- job.lua --- Job api based on libuv
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local uv = vim.loop

local M = {}
M._jobs = {}

function M.start(cmd, ...) -- {{{
  local opts = { ... }
  local opt = opts[1] or {}
end
-- }}}

local Job = {}

function Job:stdout_handler(data) -- {{{
end
-- }}}

function Job:new() -- {{{
  return setmetatable({}, { __index = Job })
end
-- }}}

-- stdout handler: fun(pid:integer, data: string) or true
-- stderr handle: fun(pid:integer, err: string) or true
-- onexit handle: fun(pid:integer, code:integer, signal: integer)

--- @param cmd string|table<string> commands
--- @param opts table job options
--- @return integer
--- keys in opts:
--- cwd: string
--- env: table
--- stdout: fun (
function M._run(cmd, opts)
  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  print('stdin', stdin)
  print('stdout', stdout)
  print('stderr', stderr)

  local handle, pid = uv.spawn('cat', {
    stdio = { stdin, stdout, stderr },
  }, function(code, signal) -- on exit
    print('exit code', code)
    print('exit signal', signal)
  end)

  print('process opened', handle, pid)

  uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data then
      print('stdout chunk', stdout, data)
    else
      print('stdout end', stdout)
    end
  end)

  uv.read_start(stderr, function(err, data)
    assert(not err, err)
    if data then
      print('stderr chunk', stderr, data)
    else
      print('stderr end', stderr)
    end
  end)

  uv.write(stdin, 'Hello World')

  uv.shutdown(stdin, function()
    print('stdin shutdown', stdin)
    uv.close(handle, function()
      print('process closed', handle, pid)
    end)
  end)
end

function M.stop(id) -- {{{
end
-- }}}

function M.send(id, data) -- {{{
end
-- }}}

function M.status(id) -- {{{
end
-- }}}

function M.list() -- {{{
end
-- }}}
function M.info(id) -- {{{
end
-- }}}

function M.chanclose(id, t) -- {{{
end
-- }}}

return M

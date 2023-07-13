local uv = require('luv')
local Async = require('cmp_dictionary.kit.Async')
local Session = require('cmp_dictionary.kit.Thread.Server.Session')

---Return current executing file directory.
---@return string
local function dirname()
  return debug.getinfo(2, "S").source:sub(2):match("(.*)/")
end

---@class cmp_dictionary.kit.Thread.Server
---@field private stdin uv.uv_pipe_t
---@field private stdout uv.uv_pipe_t
---@field private stderr uv.uv_pipe_t
---@field private dispatcher fun(session: cmp_dictionary.kit.Thread.Server.Session): nil
---@field private process? uv.uv_process_t
---@field private session? cmp_dictionary.kit.Thread.Server.Session
local Server = {}
Server.__index = Server

---Create new server instance.
---@param dispatcher fun(session: cmp_dictionary.kit.Thread.Server.Session): nil
---@return cmp_dictionary.kit.Thread.Server
function Server.new(dispatcher)
  local self = setmetatable({}, Server)
  self.dispatcher = dispatcher
  self.session = Session.new()
  self.process = nil
  return self
end

---Connect to server.
---@return cmp_dictionary.kit.Async.AsyncTask
function Server:connect()
  return Async.run(function()
    Async.schedule():await()
    local stdin = uv.new_pipe()
    local stdout = uv.new_pipe()
    local stderr = uv.new_pipe()
    self.process = uv.spawn('nvim', {
      cwd = uv.cwd(),
      args = {
        '--headless',
        '--noplugin',
        '-l',
        ('%s/_bootstrap.lua'):format(dirname()),
        vim.o.runtimepath
      },
      stdio = { stdin, stdout, stderr }
    })

    stderr:read_start(function(err, data)
      if err then
        error(err)
      end
      print(data)
    end)

    self.session:connect(stdout, stdin)
    return self.session:request('connect', {
      dispatcher = string.dump(self.dispatcher)
    }):await()
  end)
end

---Add request handler.
---@param method string
---@param callback fun(params: table): any
function Server:on_request(method, callback)
  self.session:on_request(method, callback)
end

---Add notification handler.
---@param method string
---@param callback fun(params: table)
function Server:on_notification(method, callback)
  self.session:on_notification(method, callback)
end

--- Send request.
---@param method string
---@param params table
function Server:request(method, params)
  if not self.process then
    error('Server is not connected.')
  end
  return self.session:request(method, params)
end

---Send notification.
---@param method string
---@param params table
function Server:notify(method, params)
  if not self.process then
    error('Server is not connected.')
  end
  self.session:notify(method, params)
end

---Kill server process.
function Server:kill()
  if self.process then
    local ok, err = self.process:kill('SIGINT')
    if not ok then
      error(err)
    end
    self.process = nil
  end
end

return Server

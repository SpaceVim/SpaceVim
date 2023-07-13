---@diagnostic disable: invisible
local mpack = require('mpack')
local Async = require('cmp_dictionary.kit.Async')

---Encode data to msgpack.
---@param v any
---@return string
local function encode(v)
  if v == nil then
    return mpack.encode(mpack.NIL)
  end
  return mpack.encode(v)
end

---@class cmp_dictionary.kit.Thread.Server.Session
---@field private mpack_session any
---@field private reader uv.uv_pipe_t
---@field private writer uv.uv_pipe_t
---@field private _on_request table<string, fun(params: table): any>
---@field private _on_notification table<string, fun(params: table): nil>
local Session = {}
Session.__index = Session

---Create new session.
---@return cmp_dictionary.kit.Thread.Server.Session
function Session.new()
  local self = setmetatable({}, Session)
  self.mpack_session = mpack.Session({ unpack = mpack.Unpacker() })
  self.reader = nil
  self.writer = nil
  self._on_request = {}
  self._on_notification = {}
  return self
end

---Connect reader/writer.
---@param reader uv.uv_pipe_t
---@param writer uv.uv_pipe_t
function Session:connect(reader, writer)
  self.reader = reader
  self.writer = writer

  self.reader:read_start(function(err, data)
    if err then
      error(err)
    end

    local offset = 1
    local length = #data
    while offset <= length do
      local type, id_or_cb, method_or_error, params_or_result, new_offset = self.mpack_session:receive(data, offset)
      if type == 'request' then
        local request_id, method, params = id_or_cb, method_or_error, params_or_result
        Async.resolve():next(function()
          return Async.run(function()
            return self._on_request[method](params)
          end)
        end):next(function(res)
          self.writer:write(self.mpack_session:reply(request_id) .. encode(mpack.NIL) .. encode(res))
        end):catch(function(err_)
          self.writer:write(self.mpack_session:reply(request_id) .. encode(err_) .. encode(mpack.NIL))
        end)
      elseif type == 'notification' then
        local method, params = method_or_error, params_or_result
        self._on_notification[method](params)
      elseif type == 'response' then
        local callback, err_, res = id_or_cb, method_or_error, params_or_result
        if err_ == mpack.NIL then
          callback(nil, res)
        else
          callback(err_, nil)
        end
      end
      offset = new_offset
    end
  end)
end

---Add request handler.
---@param method string
---@param callback fun(params: table): any
function Session:on_request(method, callback)
  self._on_request[method] = callback
end

---Add notification handler.
---@param method string
---@param callback fun(params: table)
function Session:on_notification(method, callback)
  self._on_notification[method] = callback
end

---Send request to the peer.
---@param method string
---@param params table
---@return cmp_dictionary.kit.Async.AsyncTask
function Session:request(method, params)
  return Async.new(function(resolve, reject)
    local request = self.mpack_session:request(function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    self.writer:write(request .. encode(method) .. encode(params))
  end)
end

---Send notification to the peer.
---@param method string
---@param params table
function Session:notify(method, params)
  self.writer:write(self.mpack_session:notify() .. encode(method) .. encode(params))
end

return Session

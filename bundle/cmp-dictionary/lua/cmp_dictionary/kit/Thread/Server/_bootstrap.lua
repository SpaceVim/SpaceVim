vim.o.runtimepath = _G.arg[1]

local uv = require('luv')
local Session = require('cmp_dictionary.kit.Thread.Server.Session')

local stdin = uv.new_pipe()
stdin:open(0)
local stdout = uv.new_pipe()
stdout:open(1)

local session = Session.new()
session:connect(stdin, stdout)

session:on_request('connect', function(params)
  loadstring(params.dispatcher)(session)
end)

while true do
  uv.run('once')
end

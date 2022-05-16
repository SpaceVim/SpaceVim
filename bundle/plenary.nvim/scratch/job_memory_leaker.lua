require('plenary.reload').reload_module('plenary')

local Job = require('plenary.job')

print("STARTING:", start_mem)

collectgarbage('collect')
start_mem = collectgarbage('count')
local inter_mem = {}
local final_mem = nil
local after_mem = nil

for i = 1, 10 do
  local x = Job:new {
    command = 'fdfind',
    args = nil,
    cwd = '/home/tj/',

    enable_recording = false,
    -- writer = writer,

    -- on_stdout = on_output,
    -- on_stderr = on_output,

    on_exit = function()
      table.insert(inter_mem, collectgarbage('count'))
    end,
  }:sync()
end

final_mem = collectgarbage('count')
collectgarbage('collect')
after_mem = collectgarbage('count')

print("AFTER   :", start_mem)
print(vim.inspect(inter_mem))
print(final_mem, after_mem)

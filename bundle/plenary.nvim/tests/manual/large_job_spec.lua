require("plenary.reload").reload_module "plenary"

local Job = require "plenary.job"
local profiler = require "plenary.profile.lua_profiler"

profiler.start()

local start = vim.fn.reltime()
local finish = nil

local results = {}

local j = Job:new {
  command = "fdfind",

  cwd = "~/plugins/",

  enable_handlers = false,

  on_stdout = function(_, data)
    table.insert(results, data)
  end,

  -- on_exit = vim.schedule_wrap(function()
  --   finish = vim.fn.reltime(start)
  -- end),
}

pcall(function()
  j:sync(2000, 5)
end)
finish = vim.fn.reltime(start)

profiler.stop()
profiler.report "/home/tj/tmp/temp.txt"

if finish == nil then
  print "Did not finish :'("
else
  print("finished in:", vim.fn.reltimestr(finish))
end

collectgarbage()
print(collectgarbage "count")

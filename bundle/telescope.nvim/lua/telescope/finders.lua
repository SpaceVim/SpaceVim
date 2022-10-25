local Job = require "plenary.job"

local make_entry = require "telescope.make_entry"
local log = require "telescope.log"

local async_static_finder = require "telescope.finders.async_static_finder"
local async_oneshot_finder = require "telescope.finders.async_oneshot_finder"
local async_job_finder = require "telescope.finders.async_job_finder"

local finders = {}

local _callable_obj = function()
  local obj = {}

  obj.__index = obj
  obj.__call = function(t, ...)
    return t:_find(...)
  end

  obj.close = function() end

  return obj
end

--[[ =============================================================

    JobFinder

Uses an external Job to get results. Processes results as they arrive.

For more information about how Jobs are implemented, checkout 'plenary.job'

-- ============================================================= ]]
local JobFinder = _callable_obj()

--- Create a new finder command
---
---@param opts table Keys:
--     fn_command function The function to call
function JobFinder:new(opts)
  opts = opts or {}

  assert(not opts.results, "`results` should be used with finder.new_table")
  assert(not opts.static, "`static` should be used with finder.new_oneshot_job")

  local obj = setmetatable({
    entry_maker = opts.entry_maker or make_entry.gen_from_string(opts),
    fn_command = opts.fn_command,
    cwd = opts.cwd,
    writer = opts.writer,

    -- Maximum number of results to process.
    --  Particularly useful for live updating large queries.
    maximum_results = opts.maximum_results,
  }, self)

  return obj
end

function JobFinder:_find(prompt, process_result, process_complete)
  log.trace "Finding..."

  if self.job and not self.job.is_shutdown then
    log.debug "Shutting down old job"
    self.job:shutdown()
  end

  local on_output = function(_, line, _)
    if not line or line == "" then
      return
    end

    if self.entry_maker then
      line = self.entry_maker(line)
    end

    process_result(line)
  end

  local opts = self:fn_command(prompt)
  if not opts then
    return
  end

  local writer = nil
  if opts.writer and Job.is_job(opts.writer) then
    writer = opts.writer
  elseif opts.writer then
    writer = Job:new(opts.writer)
  end

  self.job = Job:new {
    command = opts.command,
    args = opts.args,
    cwd = opts.cwd or self.cwd,

    maximum_results = self.maximum_results,

    writer = writer,

    enable_recording = false,

    on_stdout = on_output,
    -- on_stderr = on_output,

    on_exit = function()
      process_complete()
    end,
  }

  self.job:start()
end

local DynamicFinder = _callable_obj()

function DynamicFinder:new(opts)
  opts = opts or {}

  assert(not opts.results, "`results` should be used with finder.new_table")
  assert(not opts.static, "`static` should be used with finder.new_oneshot_job")

  local obj = setmetatable({
    curr_buf = opts.curr_buf,
    fn = opts.fn,
    entry_maker = opts.entry_maker or make_entry.gen_from_string(opts),
  }, self)

  return obj
end

function DynamicFinder:_find(prompt, process_result, process_complete)
  local results = self.fn(prompt)

  for _, result in ipairs(results) do
    if process_result(self.entry_maker(result)) then
      return
    end
  end

  process_complete()
end

--- Return a new Finder
--
-- Use at your own risk.
-- This opts dictionary is likely to change, but you are welcome to use it right now.
-- I will try not to change it needlessly, but I will change it sometimes and I won't feel bad.
finders._new = function(opts)
  assert(not opts.results, "finder.new is deprecated with `results`. You should use `finder.new_table`")
  return JobFinder:new(opts)
end

finders.new_async_job = function(opts)
  if opts.writer then
    return finders._new(opts)
  end

  return async_job_finder(opts)
end

finders.new_job = function(command_generator, entry_maker, _, cwd)
  return async_job_finder {
    command_generator = command_generator,
    entry_maker = entry_maker,
    cwd = cwd,
  }
end

--- One shot job
---@param command_list string[]: Command list to execute.
---@param opts table: stuff
--         @key entry_maker function Optional: function(line: string) => table
--         @key cwd string
finders.new_oneshot_job = function(command_list, opts)
  opts = opts or {}

  assert(not opts.results, "`results` should be used with finder.new_table")

  command_list = vim.deepcopy(command_list)
  local command = table.remove(command_list, 1)

  return async_oneshot_finder {
    entry_maker = opts.entry_maker or make_entry.gen_from_string(opts),

    cwd = opts.cwd,
    maximum_results = opts.maximum_results,

    fn_command = function()
      return {
        command = command,
        args = command_list,
      }
    end,
  }
end

--- Used to create a finder for a Lua table.
-- If you only pass a table of results, then it will use that as the entries.
--
-- If you pass a table, and then a function, it's used as:
--  results table, the results to run on
--  entry_maker function, the function to convert results to entries.
finders.new_table = function(t)
  return async_static_finder(t)
end

finders.new_dynamic = function(t)
  return DynamicFinder:new(t)
end

return finders

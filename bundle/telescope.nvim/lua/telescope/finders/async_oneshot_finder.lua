local async = require "plenary.async"
local async_job = require "telescope._"
local LinesPipe = require("telescope._").LinesPipe

local make_entry = require "telescope.make_entry"

local await_count = 1000

return function(opts)
  opts = opts or {}

  local entry_maker = opts.entry_maker or make_entry.gen_from_string(opts)
  local cwd = opts.cwd
  local env = opts.env
  local fn_command = assert(opts.fn_command, "Must pass `fn_command`")

  local results = vim.F.if_nil(opts.results, {})
  local num_results = #results

  local job_started = false
  local job_completed = false
  local stdout = nil

  local job

  return setmetatable({
    close = function()
      if job then
        job:close()
      end
    end,
    results = results,
    entry_maker = entry_maker,
  }, {
    __call = function(_, prompt, process_result, process_complete)
      if not job_started then
        local job_opts = fn_command()

        -- TODO: Handle writers.
        -- local writer
        -- if job_opts.writer and Job.is_job(job_opts.writer) then
        --   writer = job_opts.writer
        -- elseif job_opts.writer then
        --   writer = Job:new(job_opts.writer)
        -- end

        stdout = LinesPipe()
        job = async_job.spawn {
          command = job_opts.command,
          args = job_opts.args,
          cwd = cwd,
          env = env,

          stdout = stdout,
        }

        job_started = true
      end

      if not job_completed then
        if not vim.tbl_isempty(results) then
          for _, v in ipairs(results) do
            process_result(v)
          end
        end
        for line in stdout:iter(false) do
          num_results = num_results + 1

          if num_results % await_count then
            async.util.scheduler()
          end

          local v = entry_maker(line)
          results[num_results] = v
          process_result(v)
        end

        process_complete()
        job_completed = true

        return
      end

      local current_count = num_results
      for index = 1, current_count do
        -- TODO: Figure out scheduling...
        if index % await_count then
          async.util.scheduler()
        end

        if process_result(results[index]) then
          break
        end
      end

      if job_completed then
        process_complete()
      end
    end,
  })
end

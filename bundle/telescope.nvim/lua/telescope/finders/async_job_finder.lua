local async_job = require "telescope._"
local LinesPipe = require("telescope._").LinesPipe

local make_entry = require "telescope.make_entry"
local log = require "telescope.log"

return function(opts)
  log.trace("Creating async_job:", opts)
  local entry_maker = opts.entry_maker or make_entry.gen_from_string(opts)

  local fn_command = function(prompt)
    local command_list = opts.command_generator(prompt)
    if command_list == nil then
      return nil
    end

    local command = table.remove(command_list, 1)

    local res = {
      command = command,
      args = command_list,
    }

    return res
  end

  local job

  local callable = function(_, prompt, process_result, process_complete)
    if job then
      job:close(true)
    end

    local job_opts = fn_command(prompt)
    if not job_opts then
      return
    end

    local writer = nil
    -- if job_opts.writer and Job.is_job(job_opts.writer) then
    --   writer = job_opts.writer
    if opts.writer then
      error "async_job_finder.writer is not yet implemented"
      writer = async_job.writer(opts.writer)
    end

    local stdout = LinesPipe()

    job = async_job.spawn {
      command = job_opts.command,
      args = job_opts.args,
      cwd = job_opts.cwd or opts.cwd,
      env = job_opts.env or opts.env,
      writer = writer,

      stdout = stdout,
    }

    for line in stdout:iter(true) do
      if process_result(entry_maker(line)) then
        return
      end
    end

    process_complete()
  end

  return setmetatable({
    close = function()
      if job then
        job:close(true)
      end
    end,
  }, {
    __call = callable,
  })
end

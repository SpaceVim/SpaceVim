local Job = require "plenary.job"

local has_all_executables = function(execs)
  for _, e in ipairs(execs) do
    if vim.fn.executable(e) == 0 then
      return false
    end
  end

  return true
end

describe("Job", function()
  describe("> cat manually >", function()
    it("should split simple stdin", function()
      local results = {}
      local job = Job:new {
        command = "cat",

        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:start()
      job:send "hello\n"
      job:send "world\n"
      job:shutdown()

      assert.are.same(job:result(), { "hello", "world" })
      assert.are.same(job:result(), results)
    end)

    it("should allow empty strings", function()
      local results = {}
      local job = Job:new {
        command = "cat",

        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:start()
      job:send "hello\n"
      job:send "\n"
      job:send "world\n"
      job:send "\n"
      job:shutdown()

      assert.are.same(job:result(), { "hello", "", "world", "" })
      assert.are.same(job:result(), results)
    end)

    it("should split stdin across newlines", function()
      local results = {}
      local job = Job:new {
        -- writer = "hello\nword\nthis is\ntj",
        command = "cat",

        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:start()
      job:send "hello\nwor"
      job:send "ld\n"
      job:shutdown()

      assert.are.same(job:result(), { "hello", "world" })
      assert.are.same(job:result(), results)
    end)

    pending("should split stdin across newlines with no ending newline", function()
      local results = {}
      local job = Job:new {
        -- writer = "hello\nword\nthis is\ntj",
        command = "cat",

        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:start()
      job:send "hello\nwor"
      job:send "ld"
      job:shutdown()

      assert.are.same(job:result(), { "hello", "world" })
      assert.are.same(job:result(), results)
    end)

    it("should return last line when there is ending newline", function()
      local results = {}
      local job = Job:new {
        command = "echo",

        args = { "-e", "test1\ntest2" },

        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:sync()

      assert.are.same(job:result(), { "test1", "test2" })
      assert.are.same(job:result(), results)
    end)

    pending("should return last line when there is no ending newline", function()
      local results = {}
      local job = Job:new {
        command = "echo",

        args = { "-en", "test1\ntest2" },

        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:sync()

      assert.are.same(job:result(), { "test1", "test2" })
      assert.are.same(job:result(), results)
    end)
  end)

  describe("env", function()
    it("should be possible to set one env variable with an array", function()
      local results = {}
      local job = Job:new {
        command = "env",
        env = { "A=100" },
        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:sync()

      assert.are.same(job:result(), { "A=100" })
      assert.are.same(job:result(), results)
    end)

    it("should be possible to set multiple env variables with an array", function()
      local results = {}
      local job = Job:new {
        command = "env",
        env = { "A=100", "B=test" },
        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:sync()

      assert.are.same(job:result(), { "A=100", "B=test" })
      assert.are.same(job:result(), results)
    end)

    it("should be possible to set one env variable with a map", function()
      local results = {}
      local job = Job:new {
        command = "env",
        env = { "A=100" },
        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:sync()

      assert.are.same(job:result(), { "A=100" })
      assert.are.same(job:result(), results)
    end)

    it("should be possible to set one env variable with spaces", function()
      local results = {}
      local job = Job:new {
        command = "env",
        env = { "A=This is a long env var" },
        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:sync()

      assert.are.same(job:result(), { "A=This is a long env var" })
      assert.are.same(job:result(), results)
    end)

    it("should be possible to set one env variable with spaces and a map", function()
      local results = {}
      local job = Job:new {
        command = "env",
        env = { ["A"] = "This is a long env var" },
        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:sync()

      assert.are.same(job:result(), { "A=This is a long env var" })
      assert.are.same(job:result(), results)
    end)

    it("should be possible to set multiple env variables with a map", function()
      local results = {}
      local job = Job:new {
        command = "env",
        env = { ["A"] = 100, ["B"] = "test" },
        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:sync()

      local expected = { "A=100", "B=test" }
      local found = { false, false }
      for k, v in ipairs(job:result()) do
        for _, w in ipairs(expected) do
          if v == w then
            found[k] = true
          end
        end
      end

      assert.are.same({ true, true }, found)
      assert.are.same(job:result(), results)
    end)

    it("should be possible to set multiple env variables with both, array and map", function()
      local results = {}
      local job = Job:new {
        command = "env",
        env = { ["A"] = 100, "B=test" },
        on_stdout = function(_, data)
          table.insert(results, data)
        end,
      }

      job:sync()

      local expected = { "A=100", "B=test" }
      local found = { false, false }
      for k, v in ipairs(job:result()) do
        for _, w in ipairs(expected) do
          if v == w then
            found[k] = true
          end
        end
      end

      assert.are.same({ true, true }, found)
      assert.are.same(job:result(), results)
    end)
  end)

  describe("> simple ls >", function()
    it("should match systemlist", function()
      local ls_results = vim.fn.systemlist "ls -l"

      local job = Job:new {
        command = "ls",
        args = { "-l" },
      }

      job:sync()
      assert.are.same(job:result(), ls_results)
    end)

    it("should match larger systemlist", function()
      local results = vim.fn.systemlist "find"
      local stdout_results = {}

      local job = Job:new {
        command = "find",

        on_stdout = function(_, line)
          table.insert(stdout_results, line)
        end,
      }

      job:sync()
      assert.are.same(job:result(), results)
      assert.are.same(job:result(), stdout_results)
    end)

    it("should not timeout when completing fast jobs", function()
      local start = vim.loop.hrtime()

      local job = Job:new { command = "ls" }

      job:sync()

      assert((vim.loop.hrtime() - start) / 1e9 < 1, "Should not take one second to complete")
    end)

    it("should return the return code as well", function()
      local job = Job:new { command = "false" }
      local _, ret = job:sync()

      assert.are.same(1, job.code)
      assert.are.same(1, ret)
    end)
  end)

  describe("chain", function()
    it("should always run the next job when using and_then", function()
      local results = {}

      local first_job = Job:new {
        command = "env",
        env = { ["a"] = "1" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      local second_job = Job:new {
        command = "env",
        env = { ["b"] = "2" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      local third_job = Job:new { command = "false" }

      local fourth_job = Job:new {
        command = "env",
        env = { ["c"] = "3" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      first_job:and_then(second_job)
      second_job:and_then(third_job)
      third_job:and_then(fourth_job)

      first_job:sync()
      second_job:wait()
      third_job:wait()
      fourth_job:wait()

      assert.are.same({ "a=1", "b=2", "c=3" }, results)
      assert.are.same({ "a=1" }, first_job:result())
      assert.are.same({ "b=2" }, second_job:result())
      assert.are.same(1, third_job.code)
      assert.are.same({ "c=3" }, fourth_job:result())
    end)

    it("should only run the next job on success when using and_then_on_success", function()
      local results = {}

      local first_job = Job:new {
        command = "env",
        env = { ["a"] = "1" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      local second_job = Job:new {
        command = "env",
        env = { ["b"] = "2" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      local third_job = Job:new { command = "false" }

      local fourth_job = Job:new {
        command = "env",
        env = { ["c"] = "3" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      first_job:and_then_on_success(second_job)
      second_job:and_then_on_success(third_job)
      third_job:and_then_on_success(fourth_job)

      first_job:sync()
      second_job:wait()
      third_job:wait()

      assert.are.same({ "a=1", "b=2" }, results)
      assert.are.same({ "a=1" }, first_job:result())
      assert.are.same({ "b=2" }, second_job:result())
      assert.are.same(1, third_job.code)
      assert.are.same(nil, fourth_job.handle, "Job never started")
    end)

    it("should only run the next job on failure when using and_then_on_failure", function()
      local results = {}

      local first_job = Job:new {
        command = "false",
      }

      local second_job = Job:new {
        command = "env",
        env = { ["a"] = "1" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      local third_job = Job:new {
        command = "env",
        env = { ["b"] = "2" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      first_job:and_then_on_failure(second_job)
      second_job:and_then_on_failure(third_job)

      local _, ret = first_job:sync()
      second_job:wait()

      assert.are.same(1, first_job.code)
      assert.are.same(1, ret)
      assert.are.same({ "a=1" }, results)
      assert.are.same({ "a=1" }, second_job:result())
      assert.are.same(nil, third_job.handle, "Job never started")
    end)

    it("should run all normal functions when using after", function()
      local results = {}
      local code = 0

      local first_job = Job:new {
        command = "env",
        env = { ["a"] = "1" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      local second_job = Job:new { command = "false" }

      first_job
        :after(function()
          code = code + 10
        end)
        :and_then(second_job)
      second_job:after(function(_, c)
        code = code + c
      end)

      first_job:sync()
      second_job:wait()

      assert.are.same({ "a=1" }, results)
      assert.are.same({ "a=1" }, first_job:result())
      assert.are.same(1, second_job.code)
      assert.are.same(11, code)
    end)

    it("should run only on success normal functions when using after_success", function()
      local results = {}
      local code = 0

      local first_job = Job:new {
        command = "env",
        env = { ["a"] = "1" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      local second_job = Job:new { command = "false" }
      local third_job = Job:new { command = "true" }

      first_job:after_success(function()
        code = code + 10
      end)
      first_job:and_then_on_success(second_job)
      second_job:after_success(function(_, c)
        code = code + c
      end)
      second_job:and_then_on_success(third_job)

      first_job:sync()
      second_job:wait()

      assert.are.same({ "a=1" }, results)
      assert.are.same({ "a=1" }, first_job:result())
      assert.are.same(1, second_job.code)
      assert.are.same(10, code)
      assert.are.same(nil, third_job.handle)
    end)

    it("should run only on failure normal functions when using after_failure", function()
      local results = {}
      local code = 0

      local first_job = Job:new { command = "false" }

      local second_job = Job:new {
        command = "env",
        env = { ["a"] = "1" },
        on_stdout = function(_, line)
          table.insert(results, line)
        end,
      }

      local third_job = Job:new { command = "true" }

      first_job:after_failure(function(_, c)
        code = code + c
      end)
      first_job:and_then_on_failure(second_job)
      second_job:after_failure(function()
        code = code + 10
      end)
      second_job:and_then_on_failure(third_job)

      local _, ret = first_job:sync()
      second_job:wait()

      assert.are.same({ "a=1" }, results)
      assert.are.same({ "a=1" }, second_job:result())
      assert.are.same(1, ret)
      assert.are.same(1, first_job.code)
      assert.are.same(1, code)
      assert.are.same(0, second_job.code)
      assert.are.same(nil, third_job.handle)
    end)
  end)

  describe(".writer", function()
    pending("should allow using things like fzf", function()
      if not has_all_executables { "fzf", "fdfind" } then
        return
      end

      local stdout_results = {}

      local fzf = Job:new {
        writer = Job:new {
          command = "fdfind",
          cwd = vim.fn.expand "~/plugins/plenary.nvim/",
        },

        command = "fzf",
        args = { "--filter", "job.lua" },

        cwd = vim.fn.expand "~/plugins/plenary.nvim/",

        on_stdout = function(_, line)
          table.insert(stdout_results, line)
        end,
      }

      local results = fzf:sync()
      assert.are.same(results, stdout_results)

      -- 'job.lua' should be the best file from fzf.
      --    So make sure we're processing correctly.
      assert.are.same("lua/plenary/job.lua", results[1])
    end)

    it("should work with a table", function()
      if not has_all_executables { "fzf" } then
        return
      end

      local stdout_results = {}

      local fzf = Job:new {
        writer = { "hello", "world", "job.lua" },

        command = "fzf",
        args = { "--filter", "job.lua" },

        on_stdout = function(_, line)
          table.insert(stdout_results, line)
        end,
      }

      local results = fzf:sync()
      assert.are.same(results, stdout_results)

      -- 'job.lua' should be the best file from fzf.
      --    So make sure we're processing correctly.
      assert.are.same("job.lua", results[1])
      assert.are.same(1, #results)
    end)

    it("should work with a string", function()
      if not has_all_executables { "fzf" } then
        return
      end

      local stdout_results = {}

      local fzf = Job:new {
        writer = "hello\nworld\njob.lua",

        command = "fzf",
        args = { "--filter", "job.lua" },

        on_stdout = function(_, line)
          table.insert(stdout_results, line)
        end,
      }

      local results = fzf:sync()
      assert.are.same(results, stdout_results)

      -- 'job.lua' should be the best file from fzf.
      --    So make sure we're processing correctly.
      assert.are.same("job.lua", results[1])
      assert.are.same(1, #results)
    end)

    it("should work with a pipe", function()
      if not has_all_executables { "fzf" } then
        return
      end

      local input_pipe = vim.loop.new_pipe(false)

      local stdout_results = {}
      local fzf = Job:new {
        writer = input_pipe,

        command = "fzf",
        args = { "--filter", "job.lua" },

        on_stdout = function(_, line)
          table.insert(stdout_results, line)
        end,
      }

      fzf:start()

      input_pipe:write "hello\n"
      input_pipe:write "world\n"
      input_pipe:write "job.lua\n"
      input_pipe:close()

      fzf:shutdown()

      local results = fzf:result()
      assert.are.same(results, stdout_results)

      -- 'job.lua' should be the best file from fzf.
      --    So make sure we're processing correctly.
      assert.are.same("job.lua", results[1])
      assert.are.same(1, #results)
    end)

    it("should work with a pipe, but no final newline", function()
      if not has_all_executables { "fzf" } then
        return
      end

      local input_pipe = vim.loop.new_pipe(false)

      local stdout_results = {}
      local fzf = Job:new {
        writer = input_pipe,

        command = "fzf",
        args = { "--filter", "job.lua" },

        on_stdout = function(_, line)
          table.insert(stdout_results, line)
        end,
      }

      fzf:start()

      input_pipe:write "hello\n"
      input_pipe:write "world\n"
      input_pipe:write "job.lua"
      input_pipe:close()

      fzf:shutdown()

      local results = fzf:result()
      assert.are.same(results, stdout_results)

      -- 'job.lua' should be the best file from fzf.
      --    So make sure we're processing correctly.
      assert.are.same("job.lua", results[1])
      assert.are.same(1, #results)
    end)
  end)

  describe(":wait()", function()
    it("should respect timeout", function()
      local j = Job:new {
        command = "sleep",
        args = { "10" },
      }

      local ok = pcall(j.sync, j, 500)
      assert(not ok, "Job should fail")
    end)
  end)

  describe("enable_.*", function()
    it("should not add things to results when disabled", function()
      local job = Job:new {
        command = "ls",
        args = { "-l" },

        enable_recording = false,
      }

      local res = job:sync()
      assert(res == nil, "No results should exist")
      assert(job._stdout_results == nil, "No result table")
    end)

    it("should not call callbacks when disabled", function()
      local was_called = false
      local job = Job:new {
        command = "ls",
        args = { "-l" },

        enable_handlers = false,

        on_stdout = function()
          was_called = true
        end,
      }

      job:sync()
      assert(not was_called, "Should not be called.")
      assert(job._stdout_results == nil, "No result table")
    end)
  end)

  describe("enable_.*", function()
    it("should not add things to results when disabled", function()
      local job = Job:new {
        command = "ls",
        args = { "-l" },

        enable_recording = false,
      }

      local res = job:sync()
      assert(res == nil, "No results should exist")
      assert(job._stdout_results == nil, "No result table")
    end)

    it("should not call callbacks when disbaled", function()
      local was_called = false
      local job = Job:new {
        command = "ls",
        args = { "-l" },

        enable_handlers = false,

        on_stdout = function()
          was_called = true
        end,
      }

      job:sync()
      assert(not was_called, "Should not be called.")
      assert(job._stdout_results == nil, "No result table")
    end)
  end)

  describe("validation", function()
    it("requires options", function()
      local ok = pcall(Job.new, { command = "ls" })
      assert(not ok, "Requires options")
    end)

    it("requires command", function()
      local ok = pcall(Job.new, Job, { cmd = "ls" })
      assert(not ok, "Requires command")
    end)

    it("will not spawn jobs with invalid commands", function()
      local ok = pcall(Job.new, Job, { command = "dasowlwl" })
      assert(not ok, "Should not allow invalid executables")
    end)
  end)

  describe("on_exit", function()
    it("should only be called once for wait", function()
      local count = 0

      local job = Job:new {
        command = "ls",
        on_exit = function(...)
          count = count + 1
        end,
      }
      job:start()
      job:wait()

      assert.are.same(count, 1)
    end)

    it("should only be called once for shutdown", function()
      local count = 0

      local job = Job:new {
        command = "ls",
        on_exit = function(...)
          count = count + 1
        end,
      }
      job:start()
      job:shutdown()

      assert.are.same(count, 1)
    end)
  end)
end)

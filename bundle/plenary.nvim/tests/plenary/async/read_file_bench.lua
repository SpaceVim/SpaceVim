-- do not run this for now, the asset was removed
local a = require "plenary.async"
local async = a.async
local await = a.await
local await_all = a.await_all
local uv = vim.loop

local plenary_init = vim.api.nvim_get_runtime_file("lua/plenary/init.lua", false)[1]
local plenary_dir = vim.fn.fnamemodify(plenary_init, ":h:h:h")
local assets_dir = plenary_dir .. "/" .. "tests/plenary/async_lib/assets/"

local read_file = async(function(path)
  local err, fd = await(a.uv.fs_open(path, "r", 438))
  assert(not err, err)

  print("fd", fd)

  local err, stat = await(a.uv.fs_fstat(fd))
  assert(not err, err)

  local err, data = await(a.uv.fs_read(fd, stat.size, 0))
  assert(not err, err)

  local err = await(a.uv.fs_close(fd))
  assert(not err, err)

  return data
end)

local read_file_other = function(path, callback)
  uv.fs_open(path, "r", 438, function(err, fd)
    assert(not err, err)
    uv.fs_fstat(fd, function(err, stat)
      assert(not err, err)
      uv.fs_read(fd, stat.size, 0, function(err, data)
        assert(not err, err)
        uv.fs_close(fd, function(err)
          assert(not err, err)
          return callback(data)
        end)
      end)
    end)
  end)
end

local first_bench = async(function()
  local futures = {}

  for i = 1, 300 do
    futures[i] = read_file(assets_dir .. "syn.json")
  end

  local start = os.clock()

  await_all(futures)

  print("Elapsed time: ", os.clock() - start)
end)

local second_bench = function()
  local results = {}

  local start = os.clock()

  for i = 1, 300 do
    read_file_other(assets_dir .. "syn.json", function(data)
      results[i] = data
      if #results == 300 then
        print("Elapsed time: ", os.clock() - start)
      end
    end)
  end
end

local call_api = async(function()
  local futures = {}

  local read_and_api = async(function()
    local res = await(read_file(assets_dir .. "syn.json"))
    print("first in fast event", vim.in_fast_event())
    await(a.api.nvim_notify("Hello", 1, {}))
    print("second in fast event", vim.in_fast_event())
    print("third in fast event", vim.in_fast_event())
    return res
  end)

  for i = 1, 300 do
    futures[i] = read_and_api()
  end

  local start = os.clock()

  local res = await_all(futures)

  print("Elapsed time: ", os.clock() - start)
end)

a.run(call_api())

local profile = {}

-- bundled version of upstream jit.p until LuaJIT is updated to include
-- https://github.com/LuaJIT/LuaJIT/commit/95140c50010c0557af66dac944403a1a65dd312c
local p = require'plenary.profile.p'

---start profiling using LuaJIT profiler
---@param out name and path of log file
---@param opts table of options
---            flame (bool, default false) write log in flamegraph format
--                   (see https://github.com/jonhoo/inferno)
function profile.start(out, opts)
    out = out or "profile.log"
    opts = opts or {}
    popts = "10,i1,s,m0"
    if opts.flame then popts = popts .. ",G" end
    p.start(popts, out)
end

---stop profiling
profile.stop = p.stop

function profile.benchmark(iterations, f, ...)
  local start_time = vim.loop.hrtime()
  for _ = 1, iterations do
    f(...)
  end
  return (vim.loop.hrtime() - start_time) / 1E9
end

return profile

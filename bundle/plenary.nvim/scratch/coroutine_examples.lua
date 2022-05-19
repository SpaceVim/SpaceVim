
local f = function(xyz)
  print('calling 1', xyz)
  local foo = coroutine.yield()
  print('calling 2', foo)
  return 5
end

local x = coroutine.wrap(f)

x('bar')
x('zap')
-- x()
-- x()

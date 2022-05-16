-- module will return a mock module table, and will not register any assertions
local spy = require 'luassert.spy'
local stub = require 'luassert.stub'

local function mock_apply(object, action)
  if type(object) ~= "table" then return end
  if spy.is_spy(object) then
    return object[action](object)
  end
  for k,v in pairs(object) do
    mock_apply(v, action)
  end
  return object
end

local mock
mock = {
  new = function(object, dostub, func, self, key)
    local visited = {}
    local function do_mock(object, self, key)
      local mock_handlers = {
        ["table"] = function()
          if spy.is_spy(object) or visited[object] then return end
          visited[object] = true
          for k,v in pairs(object) do
            object[k] = do_mock(v, object, k)
          end
          return object
        end,
        ["function"] = function()
          if dostub then
            return stub(self, key, func)
          elseif self==nil then
            return spy.new(object)
          else
            return spy.on(self, key)
          end
        end
      }
      local handler = mock_handlers[type(object)]
      return handler and handler() or object
    end
    return do_mock(object, self, key)
  end,

  clear = function(object)
    return mock_apply(object, "clear")
  end,

  revert = function(object)
    return mock_apply(object, "revert")
  end
}

return setmetatable(mock, {
  __call = function(self, ...)
    -- mock originally was a function only. Now that it is a module table
    -- the __call method is required for backward compatibility
    return mock.new(...)
  end
})

PLENARY_DEBUG = PLENARY_DEBUG == nil and true or PLENARY_DEBUG

if PLENARY_DEBUG then
  require("plenary.reload").reload_module "plenary"
end

-- Lazy load everything into plenary.
local plenary = setmetatable({}, {
  __index = function(t, k)
    local ok, val = pcall(require, string.format("plenary.%s", k))

    if ok then
      rawset(t, k, val)
    end

    return val
  end,
})

return plenary

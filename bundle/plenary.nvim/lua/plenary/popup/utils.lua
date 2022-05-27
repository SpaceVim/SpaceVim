local utils = {}

utils.bounded = function(value, min, max)
  min = min or 0
  max = max or math.huge

  if min then
    value = math.max(value, min)
  end
  if max then
    value = math.min(value, max)
  end

  return value
end

utils.apply_defaults = function(original, defaults)
  if original == nil then
    original = {}
  end

  original = vim.deepcopy(original)

  for k, v in pairs(defaults) do
    if original[k] == nil then
      original[k] = v
    end
  end

  return original
end

return utils

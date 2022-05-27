local stat = {}

---Calculate mean
---@param t number[] @double
---@return number @double
stat.mean = function(t)
  local sum = 0
  local count = 0

  for _, v in pairs(t) do
    if type(v) == "number" then
      sum = sum + v
      count = count + 1
    end
  end

  return (sum / count)
end

-- Get the median of a table.
---@param t number[]
---@return number
stat.median = function(t)
  local temp = {}

  -- deep copy table so that when we sort it, the original is unchanged
  -- also weed out any non numbers
  for _, v in pairs(t) do
    if type(v) == "number" then
      table.insert(temp, v)
    end
  end

  table.sort(temp)

  -- If we have an even number of table elements or odd.
  if math.fmod(#temp, 2) == 0 then
    -- return mean value of middle two elements
    return (temp[#temp / 2] + temp[(#temp / 2) + 1]) / 2
  else
    -- return middle element
    return temp[math.ceil(#temp / 2)]
  end
end

--- Get the standard deviation of a table
---@param t number[]
stat.std_dev = function(t)
  local m, vm, result
  local sum = 0
  local count = 0

  m = stat.mean(t)

  for _, v in pairs(t) do
    if type(v) == "number" then
      vm = v - m
      sum = sum + (vm * vm)
      count = count + 1
    end
  end

  result = math.sqrt(sum / (count - 1))

  return result
end

---Get the max and min for a table
---@param t number[]
---@return number
---@return number
stat.maxmin = function(t)
  local max = -math.huge
  local min = math.huge

  for _, v in pairs(t) do
    if type(v) == "number" then
      max = math.max(max, v)
      min = math.min(min, v)
    end
  end

  return max, min
end

return stat

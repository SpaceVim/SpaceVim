local function min(a, b, c)
  local min_val = a

  if b < min_val then
    min_val = b
  end
  if c < min_val then
    min_val = c
  end

  return min_val
end

----------------------------------
--- Levenshtein distance function.
-- @tparam string s1
-- @tparam string s2
-- @treturn number the levenshtein distance
-- @within Metrics
return function(s1, s2)
  if s1 == s2 then
    return 0
  end
  if s1:len() == 0 then
    return s2:len()
  end
  if s2:len() == 0 then
    return s1:len()
  end
  if s1:len() < s2:len() then
    s1, s2 = s2, s1
  end

  local t = {}
  for i = 1, #s1 + 1 do
    t[i] = { i - 1 }
  end

  for i = 1, #s2 + 1 do
    t[1][i] = i - 1
  end

  local cost
  for i = 2, #s1 + 1 do
    for j = 2, #s2 + 1 do
      cost = (s1:sub(i - 1, i - 1) == s2:sub(j - 1, j - 1) and 0) or 1
      t[i][j] = min(t[i - 1][j] + 1, t[i][j - 1] + 1, t[i - 1][j - 1] + cost)
    end
  end

  return t[#s1 + 1][#s2 + 1]
end

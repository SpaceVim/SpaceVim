local pattern = {}

pattern._regexes = {}

pattern.regex = function(p)
  if not pattern._regexes[p] then
    pattern._regexes[p] = vim.regex(p)
  end
  return pattern._regexes[p]
end

pattern.offset = function(p, text)
  local s, e = pattern.regex(p):match_str(text)
  if s then
    return s + 1, e + 1
  end
  return nil, nil
end

pattern.matchstr = function(p, text)
  local s, e = pattern.offset(p, text)
  if s then
    return string.sub(text, s, e)
  end
  return nil
end

return pattern

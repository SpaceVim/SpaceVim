local f = {}

function f.kv_pairs(t)
  local results = {}
  for k, v in pairs(t) do
    table.insert(results, { k, v })
  end
  return results
end

function f.kv_map(fun, t)
  return vim.tbl_map(fun, f.kv_pairs(t))
end

function f.join(array, sep)
  return table.concat(vim.tbl_map(tostring, array), sep)
end

function f.partial(fun, ...)
  local args = { ... }
  return function(...)
    return fun(unpack(args), ...)
  end
end

function f.any(fun, iterable)
  for k, v in pairs(iterable) do
    if fun(k, v) then
      return true
    end
  end

  return false
end

function f.all(fun, iterable)
  for k, v in pairs(iterable) do
    if not fun(k, v) then
      return false
    end
  end

  return true
end

function f.if_nil(val, was_nil, was_not_nil)
  if val == nil then
    return was_nil
  else
    return was_not_nil
  end
end

function f.select_only(n)
  return function(...)
    local x = select(n, ...)
    return x
  end
end

f.first = f.select_only(1)
f.second = f.select_only(2)
f.third = f.select_only(3)

function f.last(...)
  local length = select("#", ...)
  local x = select(length, ...)
  return x
end

return f

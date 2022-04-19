function foo(x)
  local bar = function(a, b, c)
    return a + b + c
  end
  return bar(
    x,
    1,
    2)
end

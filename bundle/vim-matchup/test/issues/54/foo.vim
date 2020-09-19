
function! Foo(var, func)
    return a:func(a:var)
endfunction

function! Foo(list, var)
  return sort(a:list, s:function('a:var'))
endfunction


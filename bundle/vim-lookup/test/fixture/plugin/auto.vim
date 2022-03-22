function! Foo(...)
endfunction

call Foo(auto#foo#var,v:lang)
silent! echomsg auto#foo#var

call Foo(auto#foo#func(1,2))
silent! echomsg auto#foo#func()

let Bar = function('auto#foo#func')

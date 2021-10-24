let s:debug_func = {}

function! chat#debug#defind(key, value) abort
    call extend(s:debug_func, {a:key : a:value})
endfunction

function! chat#debug#getLog(key) abort
    call call(s:debug_func[a:key],[])
endfunction

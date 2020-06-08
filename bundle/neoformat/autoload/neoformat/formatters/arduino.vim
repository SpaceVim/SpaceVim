function! neoformat#formatters#arduino#enabled() abort
   return ['uncrustify', 'clangformat', 'astyle']
endfunction

function! neoformat#formatters#arduino#uncrustify() abort
    return neoformat#formatters#cpp#uncrustify()
endfunction

function! neoformat#formatters#arduino#clangformat() abort
    return neoformat#formatters#c#clangformat()
endfunction

function! neoformat#formatters#arduino#astyle() abort
    return neoformat#formatters#c#astyle()
endfunction

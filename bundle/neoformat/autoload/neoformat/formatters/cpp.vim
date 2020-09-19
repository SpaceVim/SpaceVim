function! neoformat#formatters#cpp#enabled() abort
   return ['uncrustify', 'clangformat', 'astyle']
endfunction

function! neoformat#formatters#cpp#uncrustify() abort
    return {
           \ 'exe': 'uncrustify',
           \ 'args': ['-q', '-l CPP'],
           \ 'stdin': 1,
           \ }
endfunction

function! neoformat#formatters#cpp#clangformat() abort
    return neoformat#formatters#c#clangformat()
endfunction

function! neoformat#formatters#cpp#astyle() abort
    return neoformat#formatters#c#astyle()
endfunction


function! neoformat#formatters#objc#enabled() abort
    return ['uncrustify', 'clangformat', 'astyle']
endfunction

function! neoformat#formatters#objc#uncrustify() abort
    return {
        \ 'exe': 'uncrustify',
        \ 'args': ['-q', '-l OC+'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#objc#clangformat() abort
    return neoformat#formatters#c#clangformat()
endfunction

function! neoformat#formatters#objc#astyle() abort
    return neoformat#formatters#c#astyle()
endfunction


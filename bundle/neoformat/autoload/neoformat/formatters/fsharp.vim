function! neoformat#formatters#fsharp#enabled() abort
    return ['fantomas']
endfunction

function! neoformat#formatters#fsharp#fantomas() abort
    return {
        \ 'exe': 'fantomas',
        \ 'args': ['--stdin'],
        \ 'stdin': 1
        \ }
endfunction

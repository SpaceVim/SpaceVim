function! neoformat#formatters#pawn#enabled() abort
    return ['uncrustify']
endfunction

function! neoformat#formatters#pawn#uncrustify() abort
    return {
        \ 'exe': 'uncrustify',
        \ 'args': ['-q', '-l PAWN'],
        \ 'stdin': 1,
        \ }
endfunction


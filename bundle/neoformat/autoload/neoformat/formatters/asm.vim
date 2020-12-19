function! neoformat#formatters#asm#enabled() abort
    return ['asmfmt', ]
endfunction

function! neoformat#formatters#asm#asmfmt() abort
    return {
        \ 'exe': 'asmfmt',
        \ 'stdin': 1
        \ }
endfunction

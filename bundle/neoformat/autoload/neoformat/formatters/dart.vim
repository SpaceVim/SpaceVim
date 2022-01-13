function! neoformat#formatters#dart#enabled() abort
    return ['dartfmt', 'format']
endfunction

function! neoformat#formatters#dart#dartfmt() abort
    return {
        \ 'exe': 'dartfmt',
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#dart#format() abort
    return {
        \ 'exe': 'dart',
        \ 'args': ['format'],
        \ 'replace': 1,
        \ }
endfunction

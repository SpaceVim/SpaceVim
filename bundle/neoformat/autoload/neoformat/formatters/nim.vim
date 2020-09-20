function! neoformat#formatters#nim#enabled() abort
    return ['nimpretty']
endfunction

function! neoformat#formatters#nim#nimpretty() abort
    return {
        \ 'exe': 'nimpretty',
        \ 'args': ['--backup:off'],
        \ 'replace': 1,
        \ }
endfunction

function! neoformat#formatters#bzl#enabled() abort
    return ['buildifier']
endfunction

function! neoformat#formatters#bzl#buildifier() abort
    return {
        \ 'exe': 'buildifier',
        \ 'stdin': 1
        \ }
endfunction

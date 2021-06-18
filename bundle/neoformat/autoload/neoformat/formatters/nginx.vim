function! neoformat#formatters#nginx#enabled() abort
    return ['nginxbeautifier']
endfunction

function! neoformat#formatters#nginx#nginxbeautifier() abort
    return {
        \ 'exe': 'nginxbeautifier',
        \ 'args': ['-i'],
        \ 'replace': 1,
        \ }
endfunction

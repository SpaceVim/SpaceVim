function! neoformat#formatters#htmldjango#enabled() abort
    return ['djlint']
endfunction

function! neoformat#formatters#htmldjango#djlint() abort
    return {
        \ 'exe': 'djlint',
        \ 'args': ['-', '--reformat'],
        \ 'stdin': 1,
        \ }
endfunction

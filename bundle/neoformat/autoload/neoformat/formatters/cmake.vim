function! neoformat#formatters#cmake#enabled() abort
    return ['cmakeformat']
endfunction

function! neoformat#formatters#cmake#cmakeformat() abort
    return {
        \ 'exe': 'cmake-format',
        \ 'args': ['-'],
        \ 'stdin': 1,
        \ }
endfunction

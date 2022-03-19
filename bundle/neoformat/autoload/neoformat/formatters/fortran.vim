function! neoformat#formatters#fortran#enabled() abort
    return ['fprettify']
endfunction

function! neoformat#formatters#fortran#fprettify() abort
    return {
        \ 'exe': 'fprettify',
        \ 'args': ['--silent'],
        \ 'stdin': 1
        \ }
endfunction

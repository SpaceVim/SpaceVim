" vim: ts=4 sw=4 et

function! neomake#makers#ft#cuda#EnabledMakers() abort
    return ['nvcc']
endfunction

function! neomake#makers#ft#cuda#nvcc() abort
    return {
        \ 'exe': 'nvcc',
        \ 'errorformat':
            \ '%f\(%l\): %trror: %m,'.
            \ '%f\(%l\): %tarning: %m,'.
            \ '%f\(%l\): %m',
        \ }
endfunction

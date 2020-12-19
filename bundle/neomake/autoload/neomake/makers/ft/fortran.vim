" vim: ts=4 sw=4 et

function! neomake#makers#ft#fortran#EnabledMakers() abort
    return ['gfortran']
endfunction

" Using the errorformat from syntastic
function! neomake#makers#ft#fortran#ifort() abort
    return {
        \ 'args': ['-syntax-only', '-warn'],
        \ 'errorformat':
            \ '%E%f(%l): error #%n: %m,'.
            \ '%W%f(%l): warning #%n: %m,'.
            \ '%W%f(%l): remark #%n: %m,'.
            \ '%-Z%p^,'.
            \ '%-G%.%#',
        \ }
endfunction

" Using the errorformat from syntastic
function! neomake#makers#ft#fortran#gfortran() abort
    return {
        \ 'args': ['-fsyntax-only', '-Wall', '-Wextra'],
        \ 'errorformat':
            \ '%-C %#,'.
            \ '%-C  %#%.%#,'.
            \ '%A%f:%l%[.:]%c:,'.
            \ '%Z%\m%\%%(Fatal %\)%\?%trror: %m,'.
            \ '%Z%tarning: %m,'.
            \ '%-G%.%#',
        \ }
endfunction

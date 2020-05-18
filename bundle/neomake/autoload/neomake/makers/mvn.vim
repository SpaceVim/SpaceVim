" vim: ts=4 sw=4 et

function! neomake#makers#mvn#mvn() abort
    return {
         \ 'exe': 'mvn',
         \ 'args': ['install'],
            \ 'errorformat': '[%tRROR]\ %f:[%l]\ %m,%-G%.%#'
         \ }
endfunction

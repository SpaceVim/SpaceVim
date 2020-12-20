" vim: ts=4 sw=4 et

function! neomake#makers#ft#sml#EnabledMakers() abort
    return ['smlnj']
endfunction

" This comes straight out of syntastic.
function! neomake#makers#ft#sml#smlnj() abort
    return {
        \ 'exe': 'sml',
        \ 'errorformat':
            \ '%E%f:%l%\%.%c %trror: %m,' .
            \ '%E%f:%l%\%.%c-%\d%\+%\%.%\d%\+ %trror: %m,' .
            \ '%W%f:%l%\%.%c %tarning: %m,' .
            \ '%W%f:%l%\%.%c-%\d%\+%\%.%\d%\+ %tarning: %m,' .
            \ '%C%\s%\+%m,' .
            \ '%-G%.%#'
        \ }
endfunction

function! neomake#makers#ft#spec#EnabledMakers() abort
    return ['rpmlint']
endfunction

function! neomake#makers#ft#spec#rpmlint() abort
    return {
        \ 'errorformat':
        \     '%E%f:%l: E: %m,' .
        \     '%E%f: E: %m,' .
        \     '%W%f:%l: W: %m,' .
        \     '%W%f: W: %m,' .
        \     '%-G%.%#'
        \ }
endfunction

" vim: ts=4 sw=4 et

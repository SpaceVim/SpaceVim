function! neomake#makers#ft#crystal#EnabledMakers() abort
    return ['crystal', 'ameba']
endfunction

function! neomake#makers#ft#crystal#crystal() abort
    " from vim-crystal
    return {
        \ 'args': ['run', '--no-color', '--no-codegen'],
        \ 'errorformat':
                \ '%ESyntax error in line %l: %m,'.
                \ '%ESyntax error in %f:%l: %m,'.
                \ '%EError in %f:%l: %m,'.
                \ '%C%p^,'.
                \ '%-C%.%#'
        \ }
endfunction

function! neomake#makers#ft#crystal#ameba() abort
    " from vim-crystal
    return {
        \ 'args': ['--format', 'flycheck'],
        \ 'errorformat': '%f:%l:%c: %t: %m'
        \ }
endfunction
" vim: ts=4 sw=4 et

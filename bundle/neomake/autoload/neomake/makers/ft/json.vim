function! neomake#makers#ft#json#EnabledMakers() abort
    return ['jsonlint']
endfunction

function! neomake#makers#ft#json#jsonlintpy() abort
    return {
        \ 'exe': 'jsonlint-py',
        \ 'args': ['--strict'],
        \ 'errorformat':
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,',
        \ }
endfunction

function! neomake#makers#ft#json#jsonlint() abort
    return {
        \ 'args': ['--compact'],
        \ 'errorformat':
            \ '%ELine %l:%c,'.
            \ '%Z\\s%#Reason: %m,'.
            \ '%C%.%#,'.
            \ '%f: line %l\, col %c\, %m,'.
            \ '%-G%.%#'
        \ }
endfunction

function! neomake#makers#ft#json#eslint() abort
    let maker = neomake#makers#ft#javascript#eslint()
    let maker.args += ['--plugin', 'json']
    return maker
endfunction

function! neomake#makers#ft#json#eslint_d() abort
    let maker = neomake#makers#ft#javascript#eslint_d()
    let maker.args += ['--plugin', 'json']
    return maker
endfunction
" vim: ts=4 sw=4 et

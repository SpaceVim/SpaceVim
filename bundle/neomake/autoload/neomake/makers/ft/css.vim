scriptencoding utf8

function! neomake#makers#ft#css#EnabledMakers() abort
    return ['csslint', 'stylelint']
endfunction

function! neomake#makers#ft#css#csslint() abort
    return {
        \ 'args': ['--format=compact'],
        \ 'errorformat':
        \   '%-G,'.
        \   '%-G%f: lint free!,'.
        \   '%f: line %l\, col %c\, %trror - %m,'.
        \   '%f: line %l\, col %c\, %tarning - %m,'.
        \   '%f: line %l\, col %c\, %m,'.
        \   '%f: %tarning - %m'
        \ }
endfunction

function! neomake#makers#ft#css#stylelint() abort
    let maker = {
          \ 'errorformat':
          \   '%-P%f,'.
          \   '%W%*\s%l:%c%*\s✖  %m,'.
          \   '%-Q,'.
          \   '%+EError: No configuration provided for %f,%-C    %.%#'
          \ }

    function! maker.postprocess(entry) abort
        let a:entry.text = substitute(a:entry.text, '\v\s\s+(.{-})\s*$', ' [\1]', 'g')
    endfunction

    return maker
endfunction
" vim: ts=4 sw=4 et

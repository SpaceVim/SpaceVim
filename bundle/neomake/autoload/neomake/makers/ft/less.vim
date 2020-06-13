" vim: ts=4 sw=4 et

function! neomake#makers#ft#less#EnabledMakers() abort
    return executable('stylelint') ? ['stylelint'] : ['lessc']
endfunction

function! neomake#makers#ft#less#lessc() abort
    return {
        \ 'args': ['--lint', '--no-color'],
        \ 'errorformat':
            \ '%m in %f on line %l\, column %c:,' .
            \ '%m in %f:%l:%c,' .
            \ '%-G%.%#'
    \ }
endfunction

function! neomake#makers#ft#less#stylelint() abort
    return neomake#makers#ft#css#stylelint()
endfunction

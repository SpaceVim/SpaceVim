" vim: ts=4 sw=4 et

function! neomake#makers#ft#scss#EnabledMakers() abort
    return executable('stylelint') ? ['stylelint'] : executable('sass-lint') ? ['sasslint'] : ['scsslint']
endfunction

function! neomake#makers#ft#scss#sasslint() abort
    return {
        \ 'exe': 'sass-lint',
        \ 'args': ['--no-exit', '--verbose', '--format', 'compact'],
        \ 'errorformat': neomake#makers#ft#javascript#eslint()['errorformat']
        \ }
endfunction

function! neomake#makers#ft#scss#scsslint() abort
    return {
        \ 'exe': 'scss-lint',
        \ 'errorformat': '%A%f:%l:%v [%t] %m,' .
        \                '%A%f:%l [%t] %m'
    \ }
endfunction

function! neomake#makers#ft#scss#stylelint() abort
    return neomake#makers#ft#css#stylelint()
endfunction

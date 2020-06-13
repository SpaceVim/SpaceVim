" vim: ts=4 sw=4 et

function! neomake#makers#ft#haml#EnabledMakers() abort
    return ['hamllint']
endfunction

function! neomake#makers#ft#haml#hamllint() abort
    return {
        \ 'exe': 'haml-lint',
        \ 'args': ['--no-color'],
        \ 'errorformat': '%f:%l [%t] %m'
        \ }
endfunction

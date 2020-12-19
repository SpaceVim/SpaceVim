" vim: ts=4 sw=4 et

function! neomake#makers#ft#pug#EnabledMakers() abort
    return ['puglint']
endfunction

function! neomake#makers#ft#pug#puglint() abort
    return {
        \ 'exe': 'pug-lint',
        \ 'args': ['--reporter', 'inline'],
        \ 'errorformat': '%f:%l:%c %m'
        \ }
endfunction

" vim: ts=4 sw=4 et

function! neomake#makers#ft#jade#EnabledMakers() abort
    return ['jadelint']
endfunction

function! neomake#makers#ft#jade#jadelint() abort
    return {
        \ 'exe': 'jade-lint',
        \ 'args': ['--reporter', 'inline'],
        \ 'errorformat': '%f:%l:%c %m'
        \ }
endfunction

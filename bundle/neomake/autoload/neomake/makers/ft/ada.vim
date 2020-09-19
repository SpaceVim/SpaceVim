function! neomake#makers#ft#ada#EnabledMakers() abort
    return ['gcc']
endfunction

function! neomake#makers#ft#ada#gcc() abort
    return {
        \ 'args': ['-c', '-x', 'ada', '-gnatc'],
        \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%f:%l:%c: %m,' .
            \ '%f:%l: %m'
        \ }
endfunction
" vim: ts=4 sw=4 et

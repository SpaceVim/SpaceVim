" vim: ts=4 sw=4 et

function! neomake#makers#sbt#sbt() abort
    return {
        \ 'exe': 'sbt',
        \ 'args': ['-Dsbt.log.noformat=true', 'compile'],
        \ 'errorformat':
            \ '%E[%trror]\ %f:%l:%c:\ %m,' .
            \ '%-Z[error]\ %p^,' .
            \ '%-C%.%#,' .
            \ '%-G%.%#'
    \ }
endfunction

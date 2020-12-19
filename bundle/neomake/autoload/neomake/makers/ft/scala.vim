" vim: ts=4 sw=4 et
function! neomake#makers#ft#scala#EnabledMakers() abort
    " use let g:neomake_scala_enabled_makers = ['fsc','scalastyle'] for fsc
    let makers = ['scalac', 'scalastyle']
    return makers
endfunction

function! neomake#makers#ft#scala#fsc() abort
    return {
        \ 'args': [
            \ '-Ystop-after:parser'
        \ ],
        \ 'errorformat':
            \ '%E%f:%l: %trror: %m,' .
            \ '%Z%p^,' .
            \ '%-G%.%#'
        \ }
endfunction

function! neomake#makers#ft#scala#scalac() abort
    return {
        \ 'args': [
            \ '-Ystop-after:parser'
        \ ],
        \ 'errorformat':
            \ '%E%f:%l: %trror: %m,' .
            \ '%Z%p^,' .
            \ '%-G%.%#'
        \ }
endfunction

function! neomake#makers#ft#scala#scalastyle() abort
    return {
        \ 'errorformat':
            \ '%trror file=%f message=%m line=%l column=%c,' .
            \ '%trror file=%f message=%m line=%l,' .
            \ '%tarning file=%f message=%m line=%l column=%c,' .
            \ '%tarning file=%f message=%m line=%l'
        \ }
endfunction

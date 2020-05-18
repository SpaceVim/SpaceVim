" vim: ts=4 sw=4 et

function! neomake#makers#ft#coffee#EnabledMakers() abort
    return ['coffeelint']
endfunction

function! neomake#makers#ft#coffee#coffeelint() abort
    return {
        \ 'args': ['--reporter=csv'],
        \ 'errorformat': '%f\,%l\,%\d%#\,%trror\,%m,' .
            \ '%f\,%l\,%trror\,%m,' .
            \ '%f\,%l\,%\d%#\,%tarn\,%m,' .
            \ '%f\,%l\,%tarn\,%m'
            \ }
endfunction

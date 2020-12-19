function! neomake#makers#ft#node#SupersetOf() abort
    return 'javascript'
endfunction

function! neomake#makers#ft#node#EnabledMakers() abort
    return ['jshint', 'eslint', 'jscs']
endfunction

" vim: ts=4 sw=4 et

function! neomake#makers#ft#jasmine#SupersetOf() abort
    return 'javascript'
endfunction

function! neomake#makers#ft#jasmine#EnabledMakers() abort
    return ['jshint', 'eslint', 'jscs']
endfunction

" vim: ts=4 sw=4 et

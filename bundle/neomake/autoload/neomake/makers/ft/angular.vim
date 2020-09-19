function! neomake#makers#ft#angular#SupersetOf() abort
    return 'javascript'
endfunction

function! neomake#makers#ft#angular#EnabledMakers() abort
    return ['jshint', 'eslint', 'jscs']
endfunction

" vim: ts=4 sw=4 et

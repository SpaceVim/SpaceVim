function! neomake#makers#ft#jsx#SupersetOf() abort
    return 'javascript'
endfunction

function! neomake#makers#ft#jsx#EnabledMakers() abort
    return ['jshint', executable('eslint_d') ? 'eslint_d' : 'eslint']
endfunction

function! neomake#makers#ft#jsx#jsxhint() abort
    return neomake#makers#ft#javascript#jshint()
endfunction

function! neomake#makers#ft#jsx#stylelint() abort
    return neomake#makers#ft#css#stylelint()
endfunction

" vim: ts=4 sw=4 et

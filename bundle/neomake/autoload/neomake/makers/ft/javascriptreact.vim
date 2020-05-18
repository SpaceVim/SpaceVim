function! neomake#makers#ft#javascriptreact#SupersetOf() abort
    return 'javascript'
endfunction

function! neomake#makers#ft#javascriptreact#EnabledMakers() abort
    return ['jshint', executable('eslint_d') ? 'eslint_d' : 'eslint']
endfunction

function! neomake#makers#ft#javascriptreact#javascriptreacthint() abort
    return neomake#makers#ft#javascript#jshint()
endfunction

function! neomake#makers#ft#javascriptreact#stylelint() abort
    return neomake#makers#ft#css#stylelint()
endfunction

" vim: ts=4 sw=4 et

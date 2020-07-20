function! neomake#makers#ft#mail#EnabledMakers() abort
    return ['proselint']
endfunction

function! neomake#makers#ft#mail#proselint() abort
    return neomake#makers#ft#text#proselint()
endfunction
" vim: ts=4 sw=4 et

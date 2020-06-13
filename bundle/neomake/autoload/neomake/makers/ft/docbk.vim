function! neomake#makers#ft#docbk#EnabledMakers() abort
    return ['xmllint']
endfunction

function! neomake#makers#ft#docbk#xmllint() abort
    return neomake#makers#ft#xml#xmllint()
endfunction
" vim: ts=4 sw=4 et

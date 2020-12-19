function! neomake#makers#ft#pandoc#SupersetOf() abort
    return 'markdown'
endfunction

function! neomake#makers#ft#pandoc#EnabledMakers() abort
    return neomake#makers#ft#markdown#EnabledMakers()
endfunction
" vim: ts=4 sw=4 et

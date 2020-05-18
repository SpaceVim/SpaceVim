function! neomake#makers#ft#asciidoc#SupersetOf() abort
    return 'text'
endfunction

function! neomake#makers#ft#asciidoc#EnabledMakers() abort
    let makers = executable('asciidoctor') ? ['asciidoctor'] : ['asciidoc']
    return makers + neomake#makers#ft#text#EnabledMakers()
endfunction

function! neomake#makers#ft#asciidoc#asciidoc() abort
    return {
        \ 'errorformat':
        \   '%E%\w%\+: %tRROR: %f: line %l: %m,' .
        \   '%E%\w%\+: %tRROR: %f: %m,' .
        \   '%E%\w%\+: FAILED: %f: line %l: %m,' .
        \   '%E%\w%\+: FAILED: %f: %m,' .
        \   '%W%\w%\+: %tARNING: %f: line %l: %m,' .
        \   '%W%\w%\+: %tARNING: %f: %m,' .
        \   '%W%\w%\+: DEPRECATED: %f: line %l: %m,' .
        \   '%W%\w%\+: DEPRECATED: %f: %m',
        \ 'args': ['-o', g:neomake#compat#dev_null],
        \ }
endfunction

function! neomake#makers#ft#asciidoc#asciidoctor() abort
    return neomake#makers#ft#asciidoc#asciidoc()
endfunction
" vim: ts=4 sw=4 et

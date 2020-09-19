function! neomake#makers#ft#applescript#EnabledMakers() abort
    return ['osacompile']
endfunction

function! neomake#makers#ft#applescript#osacompile() abort
    return {
        \ 'args': ['-o', g:neomake#compat#dev_null],
        \ 'errorformat': '%f:%l: %trror: %m',
        \ }
endfunction
" vim: ts=4 sw=4 et

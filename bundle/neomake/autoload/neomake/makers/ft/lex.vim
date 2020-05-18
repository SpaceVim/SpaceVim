" vim: ts=4 sw=4 et

function! neomake#makers#ft#lex#EnabledMakers() abort
    return ['flex']
endfunction

function! neomake#makers#ft#lex#flex() abort
    return {
            \ 'errorformat': '%f:%l: %m'
         \ }
endfunction

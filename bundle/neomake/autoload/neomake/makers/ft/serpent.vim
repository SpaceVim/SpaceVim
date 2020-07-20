function! neomake#makers#ft#serpent#EnabledMakers() abort
    return ['serplint']
endfunction

function! neomake#makers#ft#serpent#serplint() abort
    return {
        \ 'exe': 'serplint',
        \ 'args': [],
        \ 'errorformat':
            \ '%f:%l:%c %t%n %m',
        \ }
endfunction
" vim: ts=4 sw=4 et

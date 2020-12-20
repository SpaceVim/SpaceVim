" vim: ts=4 sw=4 et

function! neomake#makers#ft#matlab#EnabledMakers() abort
    return ['mlint']
endfunction

function! neomake#makers#ft#matlab#mlint() abort
    return {
        \ 'args': ['-id'],
        \ 'mapexpr': "neomake_bufname.':'.v:val",
        \ 'errorformat':
        \   '%f:L %l (C %c): %m,'.
        \   '%f:L %l (C %c-%*[0-9]): %m,',
        \ }
endfunction

function! neomake#makers#ft#beancount#EnabledMakers() abort
    return ['bean_check']
endfunction

function! neomake#makers#ft#beancount#bean_check() abort
    return {
        \ 'exe': 'bean-check',
        \ 'errorformat': '%E%f:%l:%m',
        \ 'postprocess': function('neomake#postprocess#compress_whitespace'),
        \ }
endfunction
" vim: ts=4 sw=4 et

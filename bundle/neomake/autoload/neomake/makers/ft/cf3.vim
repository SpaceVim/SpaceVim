" vim: ts=4 sw=4 et

function! neomake#makers#ft#cf3#EnabledMakers() abort
    return ['cfpromises']
endfunction

function! neomake#makers#ft#cf3#cfpromises() abort
    return {
        \ 'exe': 'cf-promises',
        \ 'args': ['-cf'],
        \ 'errorformat':
            \ '%E%f:%l:%c: error: %m',
        \ }
endfunction

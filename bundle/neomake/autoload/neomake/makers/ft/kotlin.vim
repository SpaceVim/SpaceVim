" vim: ts=4 sw=4 et

function! neomake#makers#ft#kotlin#EnabledMakers() abort
    return ['ktlint']
endfunction

function! neomake#makers#ft#kotlin#ktlint() abort
    return {
        \ 'errorformat': '%E%f:%l:%c: %m',
        \ }
endfunction


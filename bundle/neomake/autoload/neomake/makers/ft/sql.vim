function! neomake#makers#ft#sql#EnabledMakers() abort
    return ['sqlint']
endfunction

function! neomake#makers#ft#sql#sqlint() abort
    return {
        \ 'errorformat':
            \ '%E%f:%l:%c:ERROR %m,' .
            \ '%W%f:%l:%c:WARNING %m,' .
            \ '%C %m'
        \ }
endfunction
" vim: ts=4 sw=4 et

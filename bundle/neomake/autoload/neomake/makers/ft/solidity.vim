function! neomake#makers#ft#solidity#EnabledMakers() abort
    return ['solium', 'solhint']
endfunction

function! neomake#makers#ft#solidity#solium() abort
    return {
        \ 'args': ['--reporter', 'gcc', '--file'],
        \ 'errorformat':
            \ '%f:%l:%c: %t%s: %m',
        \ }
endfunction

function! neomake#makers#ft#solidity#solhint() abort
    return neomake#makers#ft#javascript#eslint()
endfunction
" vim: ts=4 sw=4 et

function! neomake#makers#ft#toml#EnabledMakers() abort
    return ['tomlcheck']
endfunction

function! neomake#makers#ft#toml#tomlcheck() abort
    return {
        \ 'args': ['-f'],
        \ 'errorformat':
        \     '%E%f:%l:%c:,' .
        \     '%E%m'
        \ }
endfunction

" vim: et sw=4 ts=4
" vim: ts=4 sw=4 et

function! neomake#makers#ft#nim#EnabledMakers() abort
    return ['nim']
endfunction

function! neomake#makers#ft#nim#nim() abort
    return {
                \ 'exe': 'nim',
                \ 'args': ['--listFullPaths', '--verbosity:0', '--colors:off',
                \   '-c', 'check'],
                \ 'errorformat':
                \   '%I%f(%l\, %c) Hint: %m,' .
                \   '%W%f(%l\, %c) Warning: %m,' .
                \   '%E%f(%l\, %c) Error: %m'
                \ }
endfunction
" vim: ts=4 sw=4 et

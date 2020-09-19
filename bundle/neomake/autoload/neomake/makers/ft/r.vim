" vim: ts=4 sw=4 et

function! neomake#makers#ft#r#EnabledMakers() abort
    return ['lintr']
endfunction

function! neomake#makers#ft#r#lintr() abort
    return {
        \ 'exe': 'R',
        \ 'args': ['--slave', '--no-restore', '--no-save', '-e lintr::lint("%t")'],
        \ 'append_file': 0,
        \ 'errorformat':
        \   '%W%f:%l:%c: style: %m,' .
        \   '%W%f:%l:%c: warning: %m,' .
        \   '%E%f:%l:%c: error: %m,'
        \ }
endfunction

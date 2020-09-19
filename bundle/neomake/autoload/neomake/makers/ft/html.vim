function! neomake#makers#ft#html#tidy() abort
    " NOTE: could also have info items, but those are skipped with -e/-q, e.g.
    " 'line 7 column 1 - Info: value for attribute "id" missing quote marks'.
    return {
                \ 'args': ['-e', '-q', '--gnu-emacs', 'true'],
                \ 'errorformat': '%W%f:%l:%c: Warning: %m',
                \ }
endfunction

function! neomake#makers#ft#html#htmlhint() abort
    return {
                \ 'args': ['--format', 'unix', '--nocolor'],
                \ 'errorformat': '%f:%l:%c: %m,%-G,%-G%*\d problems',
                \ }
endfunction

function! neomake#makers#ft#html#EnabledMakers() abort
    return ['tidy', 'htmlhint']
endfunction
" vim: ts=4 sw=4 et

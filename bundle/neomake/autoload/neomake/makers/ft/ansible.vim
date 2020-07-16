" vim: ts=4 sw=4 et

function! neomake#makers#ft#ansible#EnabledMakers() abort
    return ['ansiblelint', 'yamllint']
endfunction

function! neomake#makers#ft#ansible#yamllint() abort
    return neomake#makers#ft#yaml#yamllint()
endfunction

function! neomake#makers#ft#ansible#ansiblelint() abort
    return {
        \ 'exe': 'ansible-lint',
        \ 'args': ['-p', '--nocolor'],
        \ 'errorformat': '%f:%l: [%tANSIBLE%n] %m',
        \ }
endfunction

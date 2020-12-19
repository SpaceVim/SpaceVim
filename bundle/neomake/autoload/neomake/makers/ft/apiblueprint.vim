" vim: ts=4 sw=4 et

function! neomake#makers#ft#apiblueprint#EnabledMakers() abort
    return executable('drafter') ? ['drafter'] : []
endfunction

function! neomake#makers#ft#apiblueprint#drafter() abort
    " Drafter only operates on a single file at a time, and therefore doesn't
    " bother to print out a file name with each error. We need to attach this
    " so that the quickfix list can function properly.
    return {
        \ 'args': ['-l', '-u'],
        \ 'errorformat': '%f: %t%[%^:]\\+: (%n) %m; line %l\, column %c%.%#',
        \ 'mapexpr': 'neomake_bufname . ": " . v:val'
        \ }
endfunction

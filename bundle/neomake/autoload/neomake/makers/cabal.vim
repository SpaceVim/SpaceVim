" vim: ts=4 sw=4 et

function! neomake#makers#cabal#cabal() abort
    let errorformat = join([
                \ '%A%f:%l:%c:',
                \ '%A%f:%l:%c: %m',
                \ '%+C    %m',
                \ '%-Z%[%^ ]',
                \ ], ',')
    return {
        \ 'exe': 'cabal',
        \ 'args': ['build'],
        \ 'errorformat': errorformat
        \ }
endfunction

" vim: ts=4 sw=4 et

function! neomake#makers#ft#xml#EnabledMakers() abort
    return ['xmllint']
endfunction

function! neomake#makers#ft#xml#xmllint() abort
    let args = ['--xinclude', '--postvalid', '--noout']

    return {
        \ 'args': args,
        \ 'supports_stdin': 1,
        \ 'errorformat':
            \ '%E%f:%l: error : %m,' .
            \ '%-G%f:%l: validity error : Validation failed: no DTD found %m,' .
            \ '%W%f:%l: warning : %m,' .
            \ '%W%f:%l: validity warning : %m,' .
            \ '%E%f:%l: validity error : %m,' .
            \ '%E%f:%l: parser error : %m,' .
            \ '%E%f:%l: %m,' .
            \ '%-Z%p^,' .
            \ '%-C%.%#,' .
            \ '%-G%.%#',
        \ }
endfunction

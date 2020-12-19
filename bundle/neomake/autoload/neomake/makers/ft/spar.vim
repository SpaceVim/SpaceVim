function! neomake#makers#ft#spar#EnabledMakers() abort
    return ['spar']
endfunction

function! neomake#makers#ft#spar#spar() abort
    return {
        \ 'args': ['-g', '-c'],
        \ 'errorformat':
            \ '%f:%l:%c: %m',
        \ 'nvim_job_opts': {'pty': 1}
        \ }
endfunction
" vim: ts=4 sw=4 et

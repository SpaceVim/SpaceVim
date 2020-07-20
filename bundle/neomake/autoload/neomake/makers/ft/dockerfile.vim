function! neomake#makers#ft#dockerfile#EnabledMakers() abort
    return ['hadolint']
endfunction

function! neomake#makers#ft#dockerfile#hadolint() abort
    return {
          \ 'output_stream': 'stdout',
          \ 'uses_stdin': 1,
          \ 'args': ['--format', 'tty'],
          \ 'errorformat': '%f:%l %m',
          \ }
endfunction
" vim: ts=4 sw=4 et

function! neoformat#formatters#gleam#enabled() abort
    return ['gleamformat']
endfunction

function! neoformat#formatters#gleam#gleamformat() abort
    return {
        \ 'exe': 'gleam',
        \ 'args': ['format', '--stdin'],
        \ 'stdin': 1,
        \ }
endfunction

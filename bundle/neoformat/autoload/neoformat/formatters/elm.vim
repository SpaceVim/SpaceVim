function! neoformat#formatters#elm#enabled() abort
    return ['elmformat']
endfunction

function! neoformat#formatters#elm#elmformat() abort
    return {
        \ 'exe': 'elm-format',
        \ 'args': ['--stdin', '--elm-version=0.19'],
        \ 'stdin': 1,
        \ 'try_node_exe': 1,
        \ }
endfunction

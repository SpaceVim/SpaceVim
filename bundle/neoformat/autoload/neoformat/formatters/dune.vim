function! neoformat#formatters#dune#enabled() abort
    return ['dune']
endfunction

function! neoformat#formatters#dune#dune() abort
    return {
        \ 'exe': 'dune',
        \ 'args': ['format'],
        \ 'stdin': 1
        \ }
endfunction

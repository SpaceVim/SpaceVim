function! neoformat#formatters#elixir#enabled() abort
    return ['mixformat']
endfunction

function! neoformat#formatters#elixir#mixformat() abort
    return {
        \ 'exe': 'mix',
        \ 'args': ['format', "-"],
        \ 'stdin': 1
        \ }
endfunction

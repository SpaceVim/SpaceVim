function! neoformat#formatters#erlang#enabled() abort
    return ['erlfmt']
endfunction

function! neoformat#formatters#erlang#erlfmt() abort
    return {
        \ 'exe': 'erlfmt',
        \ 'args': ["-"],
        \ 'stdin': 1
        \ }
endfunction

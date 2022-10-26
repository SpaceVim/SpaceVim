function! neoformat#formatters#gn#enabled() abort
   return ['gn']
endfunction

function! neoformat#formatters#gn#gn() abort
    return {
            \ 'exe': 'gn',
            \ 'args': ['format', '--stdin'],
            \ 'stdin': 1,
            \ }
endfunction

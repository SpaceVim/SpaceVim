function! neoformat#formatters#terraform#enabled() abort
   return ['terraform']
endfunction

function! neoformat#formatters#terraform#terraform() abort
    return {
        \ 'exe': 'terraform',
        \ 'args': ['fmt', '-write', '-'],
        \ 'stdin': 1
        \ }
endfunction

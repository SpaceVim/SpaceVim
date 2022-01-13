function! neoformat#formatters#tf() abort
   return ['tf']
endfunction

function! neoformat#formatters#tfm#tf() abort
    return {
        \ 'exe': 'terraform',
        \ 'args': ['fmt', '-write', '-'],
        \ 'stdin': 1
        \ }
endfunction

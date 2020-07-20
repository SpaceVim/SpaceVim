function! neoformat#formatters#jade#enabled() abort
   return ['pugbeautifier']
endfunction

function! neoformat#formatters#jade#pugbeautifier() abort
    return neoformat#formatters#pug#pugbeautifier()
endfunction

function! neoformat#formatters#opencl#enabled() abort
   return ['clangformat']
endfunction

function! neoformat#formatters#opencl#clangformat() abort
    return neoformat#formatters#c#clangformat()
endfunction
